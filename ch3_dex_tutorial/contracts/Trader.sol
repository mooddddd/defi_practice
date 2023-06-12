// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./interfaces/IERC20.sol";
import "./interfaces/IUniswapV2Router02.sol";
import "./interfaces/IUniswapV2Factory.sol";
import "./interfaces/IMasterChef.sol";
import "hardhat/console.sol";

contract Trader {
    // contracts
    address constant FACTORY = 0x90B06a1B5920E45c5f0aC3D701728669527bF275;
    address constant ROUTER = 0x0D827eaDe12e5f296e3Dd0e08fc38ad990dC1142;
    address constant CHEF = 0x5bc059C6fAC255702Ea697415f82e44c5ec3CB76;

    // tokens
    address constant WKLAY = 0x043c471bEe060e00A56CcD02c0Ca286808a5A436;
    address constant WHLE = 0x15308179057A1d5e56C61a612b1EADfA5F669Aad;
    
    constructor() {}

    receive () external payable {}

    // ------------- VIEW ------------- 

    function pendingReward(uint pid) external view returns (uint) {
        // TODO
        return 0;
    }

    function pendingRewardAll() external view returns (uint) {
        // TODO
        return 0;
    }

    function depositBalance(uint pid) external view returns (uint) {
        // TODO
        return 0;
    }

    // ------------- LIQUIDITY ------------- 

    function addLiquidityKlay(address token, uint amountDesired) payable external {
        // native token으로 pair된 애들이 들어오는 곳(A, B로 나누어져있지 않음)
        // 이 함수가 실행되는 시점에서는 이미 네이티브 토큰을 받은 상태! 그러므로 페어로 맺은 토큰만 amountDesired만큼 가져오면 된다
        IERC20(token).transferFrom(msg.sender, address(this), amountDesired);
        approveToken(token, ROUTER);
        IUniswapV2Router01(ROUTER).addLiquidityETH{value:msg.value}(token, amountDesired, 0, 0, msg.sender, block.timestamp+10);
    }

    function addLiquidity(address tokenA, address tokenB, uint amountA, uint amountB) external {
        // 토큰의 이동경로 : 유동성 공급자 -> 현재 이 컨트랙트의 CA(TRADER) -> 실제 풀이 생성되어 있는 곳으로 연결시킬 수 있는 컨트랙트의 CA(DEX-ROUTER) -> 실제 풀이 있는 CA(DEX-PAIR)
        // 유저에게서 유동성 토큰을 받기 위해서는 transferFrom 메서드를 사용해 함!
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

        // 현재 이 컨트랙트(TRADER)에서 ROUTER CA(DEX)로 금액을 옮겨야 하기 때문에 approve가 필요하다
        // IERC20(tokenA).approve(ROUTER, amountA), IERC20(tokenA).approve(ROUTER, amountB)를 사용해도 되고 approveToken 함수를 사용해도 된다!
        approveToken(tokenA, ROUTER);
        approveToken(tokenB, ROUTER);

        // 이 함수가 발동되면 실제로 공급이 되어야 하기 때문에 이어서 Router에서 addLiquidity를 실행시켜야 함?
        IUniswapV2Router01(ROUTER).addLiquidity(tokenA, tokenB, amountA, amountB, 0, 0, msg.sender, block.timestamp + 10 );
    }

    function removeLiquidity(address tokenA, address tokenB, uint liquidity) external {
        // 유동성을 해제하고자 하는 풀에 있는 두 토큰의 주소를 받고, 
        // 그 Pool의 LP토큰 수량을 인자값으로 받아(liquidity) 두 토큰으로 구성되어 있는 풀에서 LP토큰 수량만큼 해제시킴으로써 돌려받게 됨

        // 가장 먼저 엘피 토큰을 가져와서 유동성을 해제시킨다 => transferFrom으로 엘피토큰을 가져옴
        // 엘피토큰의 주소는 받은 두 토큰의 주소라는 인자값을 통해 뽑아야 함 => lp토큰은 factory에서 관장함, 배포 되어 있는 애 가져오면 됨!(위에서 가져옴)
        address lp = IUniswapV2Factory(FACTORY).getPair(tokenA, tokenB);
        IERC20(lp).transferFrom(msg.sender, address(this), liquidity);

        // 가져온 엘피토큰을 라우터에 보내기 전에, 라우터가 사용할 수 있도록 approve
        approveToken(lp, ROUTER);
        // 라우터에서 remove
        IUniswapV2Router01(ROUTER).removeLiquidity(tokenA, tokenB, liquidity, 0, 0, msg.sender, block.timestamp + 10);
    }

    function removeLiquidityKlay(address token, uint liquidity) external {
        // 이미 유동성 풀에 두 토큰 하나가 자체토큰으로 고정되어 있기 때문에 페어된 다른 토큰의 address와 해지할 엘피토큰의 수량만 가져오면 됨
        address lp = IUniswapV2Factory(FACTORY).getPair(token, WKLAY);
        // 여기서 WKLAY는 클레이토큰(자체토큰)을 민팅한 컨트랙트의 CA인가?
        IERC20(lp).transferFrom(msg.sender, address(this), liquidity);

        approveToken(lp, ROUTER);
        IUniswapV2Router01(ROUTER).removeLiquidityETH(token, liquidity, 0, 0, msg.sender, block.timestamp + 10);
    }

    // ------------- SWAP ------------- 

    function swapExactTokenToToken(uint amountIn, address[] calldata path) external {
        // 얼만큼 던질 건지, 어떤 순서대로 토큰을 바꿀 건지를 인자값으로 받는다
        // 먼저 유저로부터 토큰을 받아야 하기 때문에 transferFrom 사용해 inputToken을 유저의 계정으로부터 가져온다.
        // 여기서 inputToken은 던지는 토큰이기 때문에, path[]의 첫번째 index 값!
        address inputToken = path[0];
        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

        // router가 처리해줄 수 있도록 허락하기 위해 aprrove 해주기!
        approveToken(inputToken, ROUTER);
        // router에서 토큰을 교환하는 메서드를 실행!
        IUniswapV2Router01(ROUTER).swapExactTokensForTokens(amountIn, 0, path, msg.sender, block.timestamp + 10);
        // (얼마나 교환할 건지, 최소 얼만큼을 받을 건지, 어떤 토큰->어떤 토큰으로 바꿀 건지, 누구의 계좌로 바뀐 토큰이 들어갈 건지, 데드라인이 언제까진지)
    }

    function swapTokenToExactToken(uint amountOut, uint amountInMax, address[] calldata path) external {
        // 얼만큼 받고 싶은지, 최대 얼만큼 쓸 수 있는지, 어떤 순서대로 토큰을 바꿀 건지
        // => amountInMax는 슬리피지를 반영한 값이 들어가는 건가?

        // 얼만큼의 토큰을 사용해야 하는지 계산
        uint[] memory amountsIn = IUniswapV2Router01(ROUTER).getAmountsIn(amountOut, path);
        uint amountIn = amountsIn[0]; // 근데 이 값이 amountInMax값을 넘으면 안되니까 require로 한번 걸러주기!
        require(amountIn <= amountInMax, "exceed amountInMax");

        address inputToken = path[0];

        // 1) amountInMax만큼 우선 빼온 다음에 바꿔주고 나서 남은 금액 되돌려줘도 됨
        // IERC20(inputToken).transferFrom(msg.sender, address(this), amountInMax);
        // 2) 혹은 amountInMax 범위 안에서 스왑에 필요한 토큰 수량만 사용할 수도 있음! => 이런 경우 먼저 연산을 해준다. getAmountsIn 사용
        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

        // approve + 라우터에서 교환
        approveToken(inputToken, ROUTER);
        IUniswapV2Router01(ROUTER).swapTokensForExactTokens(amountOut, amountIn, path, msg.sender, block.timestamp + 10);
    }

    function swapExactKlayToToken(address[] calldata path) payable external {
        // 네이티브 토큰을 다른 토큰으로 교환!
        // path가 제대로 구성되었는지 확인(require 사용)
        require(path[0]==WKLAY, "invaild path"); // 패스의 첫번째 인자가 클레이가 맞는지 = 교환에 클레이가 사용되는 게 맞는지 확인!!
        require(msg.value > 0, "zero msg.value");

        // swap => 네이티브 토큰을 다루기 때문에 별도의 approve가 필요하지 않다! 여기서 ETH는 그냥 네이티브토큰을 의미하는 거라고 봐도 됨! 찐이더X
        IUniswapV2Router01(ROUTER).swapExactETHForTokens{ value : msg.value }(0, path, msg.sender, block.timestamp + 10);
    }

    function swapKlayToExactToken(uint amountOut, address[] calldata path) payable external {
        // 다른 토큰을 네이티브 토큰으로 교환!
        // path가 제대로 구성되었는지 확인(require 사용)
        require(path[0]==WKLAY, "invaild path"); // 패스의 첫번째 인자가 클레이가 맞는지 = 교환에 클레이가 사용되는 게 맞는지 확인!!
        require(msg.value > 0, "zero msg.value");

        // amountOut을 써서 받을 수 있는 네이티브 토큰 양 계산
        uint[] memory amountsIn = IUniswapV2Router01(ROUTER).getAmountsIn(amountOut, path); // index 0번째 값만 필요! = 필요한 네이티브 토큰 수량
        // 계산한 양을 대괄호에 넣어 스왑할 때 사용한다!
        IUniswapV2Router01(ROUTER).swapETHForExactTokens{ value : amountsIn[0] }(amountOut, path, msg.sender, block.timestamp + 10);

        // msg.value와 amountsIn[0]의 값이 차이가 날 수 있음. value 범위 내에서 amountsIn[0]을 사용해야 하기 때문에 남는 금액은 환불해줘야 함!
        // 다른 토큰 - 다른 토큰인 경우에는.... 생각해 봐야 함... 뭐가 다른지........
        if(msg.value > amountsIn[0]){
            (bool success, ) = (msg.sender).call{value : msg.value - amountsIn[0]}(new bytes(0));
            require(success, "fail to transfer KLAY");
        }
    }


    // ------------- FARM ------------- 

    function deposit(uint pid, uint amount) external {
        // TODO
    }

    function withdraw(uint pid, uint amount) external {
        // TODO
    }

    function harvest() public {
        // TODO
    }

    function claimReward() external {
        // TODO
    }

    // ------------- UTILS ------------- 

    function approveToken(address token, address spender) private {
        if (IERC20(token).allowance(address(this), spender) == 0) {
            IERC20(token).approve(spender, type(uint).max);
        }
    }
}
// SPDX-License-Idenitifer: MIT

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allownace(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address dest, uint256 amount) external returns (bool);
    function transferFrom(address src, address dest, uint256 amount) external returns (bool);

    event Transfer(address indexed src, address indexed dest, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}

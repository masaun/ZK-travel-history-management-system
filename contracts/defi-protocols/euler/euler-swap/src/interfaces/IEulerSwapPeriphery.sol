// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IEulerSwapPeriphery {
    /// @notice Swap `amountIn` of `tokenIn` for `tokenOut`, with at least `amountOutMin` received.
    /// Output tokens are sent to `receiver`. The swap will fail after `deadline` (unless `deadline` is 0).
    /// IMPORTANT: `eulerSwap` must be a trusted contract, for example created by a trusted factory.
    function swapExactIn(
        address eulerSwap,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        address receiver,
        uint256 amountOutMin,
        uint256 deadline
    ) external;

    /// @notice Swap `amountOut` of `tokenOut` for `tokenIn`, with at most `amountInMax` paid.
    /// Output tokens are sent to `receiver`. The swap will fail after `deadline` (unless `deadline` is 0).
    /// IMPORTANT: `eulerSwap` must be a trusted contract, for example created by a trusted factory.
    function swapExactOut(
        address eulerSwap,
        address tokenIn,
        address tokenOut,
        uint256 amountOut,
        address receiver,
        uint256 amountInMax,
        uint256 deadline
    ) external;

    /// @notice How much `tokenOut` can I get for `amountIn` of `tokenIn`?
    function quoteExactInput(address eulerSwap, address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        returns (uint256);

    /// @notice How much `tokenIn` do I need to get `amountOut` of `tokenOut`?
    function quoteExactOutput(address eulerSwap, address tokenIn, address tokenOut, uint256 amountOut)
        external
        view
        returns (uint256);

    /// @notice Upper-bounds on the amounts of each token that this pool can currently support swaps for.
    /// @return limitIn Max amount of `tokenIn` that can be sold.
    /// @return limitOut Max amount of `tokenOut` that can be bought.
    function getLimits(address eulerSwap, address tokenIn, address tokenOut)
        external
        view
        returns (uint256 limitIn, uint256 limitOut);
}

#!/bin/bash

# Tic-Tac-Toe in Bash
board=(1 2 3 4 5 6 7 8 9)
player="X"

print_board() {
    clear
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---+---+---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---+---+---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

check_win() {
    for i in 0 3 6; do
        if [[ "${board[i]}" == "$player" && "${board[i+1]}" == "$player" && "${board[i+2]}" == "$player" ]]; then return 0; fi
    done
    for i in 0 1 2; do
        if [[ "${board[i]}" == "$player" && "${board[i+3]}" == "$player" && "${board[i+6]}" == "$player" ]]; then return 0; fi
    done
    if [[ "${board[0]}" == "$player" && "${board[4]}" == "$player" && "${board[8]}" == "$player" ]]; then return 0; fi
    if [[ "${board[2]}" == "$player" && "${board[4]}" == "$player" && "${board[6]}" == "$player" ]]; then return 0; fi
    return 1
}

game_loop() {
    for turn in {1..9}; do
        print_board
        echo "Player $player, enter a number (1-9):"
        read -r move
        if [[ ! "$move" =~ ^[1-9]$ ]] || [[ "${board[move-1]}" == "X" ]] || [[ "${board[move-1]}" == "O" ]]; then
            echo "Invalid move. Try again."
            ((turn--))
            continue
        fi
        board[move-1]="$player"
        check_win && { print_board; echo "Player $player wins!"; exit; }
        player=$([[ "$player" == "X" ]] && echo "O" || echo "X")
    done
    print_board
    echo "It's a draw!"
}

game_loop

package main

import (
    "fmt"
    "os"
)

const (
    start = iota
    m = iota
    mu = iota
    mul = iota
    mulO = iota
    mulON = iota
    mulONN = iota
    mulONNN = iota
    mulONNNc = iota
    mulONNNcN = iota
    mulONNNcNN = iota
    mulONNNcNNN = iota
    d = iota
    do = iota
    doO = iota
    don = iota
    dona = iota
    donat = iota
    donatO = iota
)

func main() {
    bytes, err := os.ReadFile("input/3.txt")
    if err != nil {
        fmt.Print(err)
    }
    
    state := start
    
    left := 0
    right := 0
    sum1 := 0
    sum2 := 0
    
    enabled := true
    
    for _, b := range bytes {
        switch state {
            case m:
                switch b {
                    case 'u':
                        state = mu
                    default:
                        state = start
                }
            case mu:
                switch b {
                    case 'l':
                        state = mul
                    default:
                        state = start
                }
            case mul:
                switch b {
                    case '(':
                        state = mulO
                    default:
                        state = start
                }
            case mulO:
                switch b {
                    case '0','1','2','3','4','5','6','7','8','9':
                        state = mulON
                        left = int(b - '0')
                    default:
                        state = start
                }
            case mulON:
                switch b {
                    case '0','1','2','3','4','5','6','7','8','9':
                        state = mulONN
                        left = left*10 + int(b - '0')
                    case ',':
                        state = mulONNNc
                    default:
                        state = start
                }
            case mulONN:
                switch b {
                    case '0','1','2','3','4','5','6','7','8','9':
                        state = mulONNN
                        left = left*10 + int(b - '0')
                    case ',':
                        state = mulONNNc
                    default:
                        state = start
                }
            case mulONNN:
                switch b {
                    case ',':
                        state = mulONNNc
                    default:
                        state = start
                }
            case mulONNNc:
                switch b {
                    case '0','1','2','3','4','5','6','7','8','9':
                        state = mulONNNcN
                        right = int(b - '0')
                    default:
                        state = start
                }
            case mulONNNcN:
                switch b {
                    case '0','1','2','3','4','5','6','7','8','9':
                        state = mulONNNcNN
                        right = right*10 + int(b - '0')
                    case ')':
                        sum1 = sum1 + left * right
                        if enabled {
                            sum2  = sum2 + left * right
                        }
                        state = start
                    default:
                        state = start
                }
            case mulONNNcNN:
                switch b {
                    case '0','1','2','3','4','5','6','7','8','9':
                        state = mulONNNcNNN
                        right = right*10 + int(b - '0')
                    case ')':
                        sum1 = sum1 + left * right
                        if enabled {
                            sum2  = sum2 + left * right
                        }
                        state = start
                    default:
                        state = start
                }
            case mulONNNcNNN:
                switch b {
                    case ')':
                        sum1 = sum1 + left * right
                        if enabled {
                            sum2  = sum2 + left * right
                        }
                        state = start
                    default:
                        state = start
                }
            case d:
                switch b {
                    case 'o':
                        state = do
                    default:
                        state = start
                }
            case do:
                switch b {
                    case '(':
                        state = doO
                    case 'n':
                        state = don
                    default:
                        state = start
                }
            case doO:
                switch b {
                    case ')':
                        enabled = true
                        state = start
                    default:
                        state = start
                }
            case don:
                switch b {
                    case '\'':
                        state = dona
                    default:
                        state = start
                }
            case dona:
                switch b {
                    case 't':
                        state = donat
                    default:
                        state = start
                }
            case donat:
                switch b {
                    case '(':
                        state = donatO
                    default:
                        state = start
                }
            case donatO:
                switch b {
                    case ')':
                        enabled = false
                        state = start
                    default:
                        state = start
                }
            default:
                state = start
        }
        
        if state == start {
            switch b {
                case 'm':
                    state = m
                case 'd':
                    state = d
                default:
                    state = start
            }
        }
    }
    
    fmt.Printf("Task 1: %d\n", sum1)
    fmt.Printf("Task 2: %d\n", sum2)
}
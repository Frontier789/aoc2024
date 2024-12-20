use std::fs::File;
use std::io::{self, BufRead};

fn main() {
    let mut robots: Vec<_> = vec![];

    let file = File::open("input/14.txt").unwrap();
    let lines = io::BufReader::new(file).lines();
    for line in lines {
        let numbers_in_line = line
            .unwrap()
            .replace("p=", "")
            .replace(",", " ")
            .replace("v=", "");

        let nums: Vec<i32> = numbers_in_line
            .split(" ")
            .map(|string| string.parse().unwrap())
            .collect();

        if let [x, y, dx, dy] = nums[..] {
            robots.push((x, y, dx, dy));

            // println!("{}, {}, {}, {}", x, y, dx, dy);
        } else {
            panic!("Failed to parse 4 numbers from line");
        }
    }

    let width = 101;
    let height = 103;
    let time = 100;

    let mut quad1 = 0;
    let mut quad2 = 0;
    let mut quad3 = 0;
    let mut quad4 = 0;

    for (x, y, dx, dy) in &robots {
        let x = ((x + dx * time) % width + width) % width;
        let y = ((y + dy * time) % height + height) % height;

        if x != width / 2 && y != height / 2 {
            match (x < width / 2, y < height / 2) {
                (false, false) => quad1 += 1,
                (true, false) => quad2 += 1,
                (false, true) => quad3 += 1,
                (true, true) => quad4 += 1,
            }
        }
    }

    println!("Task 1: {}", quad1 * quad2 * quad3 * quad4);

    let mut min_lonelies = 10000;
    let mut best_time = 0;

    for t in 0..=10000 {
        let mut map = vec![vec![0; height as usize]; width as usize];

        for (x, y, dx, dy) in &robots {
            let x = (((x + dx * t) % width + width) % width) as usize;
            let y = (((y + dy * t) % height + height) % height) as usize;

            map[x][y] += 1;
        }

        let mut lonelies = 0;

        for j in 0..height {
            for i in 0..width {
                if map[i as usize][j as usize] != 0 {
                    let mut neighbors = 0;

                    for di in -1..=1 {
                        for dj in -1..=1 {
                            if di != 0 || dj != 0 {
                                let ii = i + di;
                                let jj = j + dj;
                                if ii >= 0 && jj >= 0 && ii < width && jj < height {
                                    if map[ii as usize][jj as usize] != 0 {
                                        neighbors += 1;
                                    }
                                }
                            }
                        }
                    }

                    if neighbors == 0 {
                        lonelies += 1;
                    }
                }
            }
        }

        if lonelies < min_lonelies {
            min_lonelies = lonelies;
            best_time = t;

            // let mut output = "".to_owned();

            // for j in 0..height as usize {
            //     for i in 0..width as usize {
            //         if map[i][j] == 0 {
            //             output += ".";
            //         } else {
            //             output += &format!("{}", map[i][j]);
            //         }
            //     }
            //     output += "\n";
            // }
            // println!("{}", output);
            // println!("Time: {}", t);
            // println!("Lonelines: {}\n\n", lonelies);
        }
    }

    println!("Task 2: {}", best_time);
}

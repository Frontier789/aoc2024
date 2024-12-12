const fs = require('node:fs');

data = undefined

try {
    data = fs.readFileSync('input/1.txt', 'utf8');
} catch (err) {
    console.error(err);
}

lines = data.split('\n');

left_list = []
right_list = []

for (let i = 0; i < lines.length; i++) {
    let line = lines[i].split('   ').map(Number);
    
    if (line.length == 2)
    {
        left_list.push(line[0]);
        right_list.push(line[1]);
    }
}

left_list.sort()
right_list.sort()

// Task 1

total_diff = 0

for (let i = 0; i < left_list.length; i++) {
    let a = left_list[i];
    let b = right_list[i];
    
    total_diff += Math.abs(a-b)
}

console.log("Part 1: ", total_diff);

// Task 2

counts = new Map()

for (let n of right_list) {
    if (n in counts) {
        counts[n] += 1;
    } else {
        counts[n] = 1;
    }
}

prodsum = 0

for (let n of left_list) {
    if (n in counts) {
        prodsum += counts[n] * n;
    }
}

console.log("Part 2: ", prodsum)
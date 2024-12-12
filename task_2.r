f <- file("input/2.txt",open="r")
lines <- readLines(f)
close(f)

is_safe <- function(numbers) {
   left_numbers  = numbers[1:length(numbers)-1]
   right_numbers = numbers[2:length(numbers)]
   
   differences = right_numbers - left_numbers
   
   change_directions = sign(differences)
   fastest_change = max(abs(differences))
   
   if (min(change_directions) != max(change_directions)) {
      return(FALSE)
   }
   
   if (fastest_change < 1 || fastest_change > 3) {
      return(FALSE)
   }
   
   return(TRUE)
}

safes_1 = 0
safes_2 = 0

for (i in 1:length(lines)) {
   numbers = scan(text=lines[i], what=numeric(), sep=" ", quiet = TRUE)

   if (is_safe(numbers)) {
      safes_1 <- safes_1 + 1
      safes_2 <- safes_2 + 1
   } else {
      for (i in 1:length(numbers)) {
         damped = numbers[-i]
         if (is_safe(damped)) {
            safes_2 <- safes_2 + 1
            break
         }
      }
   }
}

sprintf("Task 1: %d", safes_1)
sprintf("Task 2: %d", safes_2)

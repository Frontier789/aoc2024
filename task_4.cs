using System.Collections.Generic;
using System.IO;
using System;

public class Task4
{
    public static bool isXMAS(char a, char b, char c, char d) {
        if (a == 'X' && b == 'M' && c == 'A' && d == 'S') return true;
        if (a == 'S' && b == 'A' && c == 'M' && d == 'X') return true;
        return false;
    }
    
    public static bool isMAS(char a, char b, char c) {
        if (a == 'M' && b == 'A' && c == 'S') return true;
        if (a == 'S' && b == 'A' && c == 'M') return true;
        return false;
    }
    
    public static void Main(string[] args)
    {
        try
        {
            StreamReader sr = new StreamReader("input/4.txt");
            
            List<String> lines = new List<String>();
            
            while (true)
            {
                String line = sr.ReadLine();
                if (line == null) break;
                
                lines.Add(line);
            }
            sr.Close();
            
            int xmas_count = 0;
            int mas_count = 0;
            
            for (int i=0; i<lines.Count; i++)
            {
                for (int j=0; j<lines[i].Length; j++)
                {
                    if (i+3 < lines.Count) {
                        if (isXMAS(lines[i+0][j], lines[i+1][j], lines[i+2][j], lines[i+3][j])) xmas_count += 1;
                    }
                    
                    if (j+3 < lines[i].Length) {
                        if (isXMAS(lines[i][j+0], lines[i][j+1], lines[i][j+2], lines[i][j+3])) xmas_count += 1;
                    }
                    
                    if (i+3 < lines.Count && j+3 < lines[i].Length) {
                        if (isXMAS(lines[i+0][j+0], lines[i+1][j+1], lines[i+2][j+2], lines[i+3][j+3])) xmas_count += 1;
                    }
                    
                    if (i+3 < lines.Count && j+3 < lines[i].Length) {
                        if (isXMAS(lines[i+3][j+0], lines[i+2][j+1], lines[i+1][j+2], lines[i+0][j+3])) xmas_count += 1;
                    }
                    
                    
                    
                    if (i > 0 && i+1 < lines.Count && j > 0 && j+1 < lines[i].Length) {
                        if (isMAS(lines[i-1][j-1], lines[i][j], lines[i+1][j+1]) &&
                            isMAS(lines[i+1][j-1], lines[i][j], lines[i-1][j+1])) mas_count += 1;
                    }
                }
            }
            
            Console.WriteLine("Task 1: " + xmas_count);
            Console.WriteLine("Task 2: " + mas_count);
        }
        catch(Exception e)
        {
            Console.WriteLine("Error: " + e.Message);
        }
    }
}
#include <iostream>
#include <fstream>
#include <vector>
#include <string>

struct MovedBoxes
{
    bool possible;
    std::vector<std::pair<int, int>> boxes;
};

MovedBoxes boxMove(const int boxi, const int boxj, const char action, const std::vector<std::string> &map)
{
    using Spots = std::vector<std::pair<int, int>>;

    Spots spots;
    if (action == '<')
        spots = Spots{{boxi, boxj - 1}};
    else if (action == '^')
        spots = Spots{{boxi - 1, boxj}, {boxi - 1, boxj + 1}};
    else if (action == '>')
        spots = Spots{{boxi, boxj + 2}};
    else if (action == 'v')
        spots = Spots{{boxi + 1, boxj}, {boxi + 1, boxj + 1}};
    else
        return MovedBoxes{false, {}};

    MovedBoxes moved{true, {{boxi, boxj}}};

    bool first_box_part = true;

    for (const auto [i, j] : spots)
    {
        if (map[i][j] == '#')
            return MovedBoxes{false, {}};
        if (map[i][j] == '.')
            continue;
        if (map[i][j] == '[' || (map[i][j] == ']' && first_box_part))
        {
            const auto headj = map[i][j] == '[' ? j : j - 1;

            const auto moved2 = boxMove(i, headj, action, map);
            if (!moved2.possible)
                return MovedBoxes{false, {}};

            moved.boxes.insert(moved.boxes.end(), moved2.boxes.begin(), moved2.boxes.end());
        }

        first_box_part = false;
    }

    return moved;
}

int64_t gps_sum(const std::vector<std::string> &map, const char box_char)
{
    int64_t sum = 0;

    for (int i = 0; i < map.size(); ++i)
    {
        for (int j = 0; j < map[i].length(); ++j)
        {
            if (map[i][j] == box_char)
            {
                const auto gps = i * 100 + j;

                sum += gps;
            }
        }
    }

    return sum;
}

int main()
{
    std::ifstream in("input/15.txt");
    std::string line;

    std::vector<std::string> original_map;
    std::string actions;

    bool loading_map = true;

    while (std::getline(in, line))
    {
        if (line.length() == 0)
        {
            loading_map = false;
            continue;
        }

        if (loading_map)
        {
            original_map.push_back(line);
        }
        else
        {
            actions += line;
        }

        // std::cout << line << std::endl;
    }

    auto map = original_map;

    const auto height = map.size();
    auto width = map[0].length();

    int ri, rj;

    for (int i = 0; i < height; ++i)
    {
        for (int j = 0; j < width; ++j)
        {
            if (map[i][j] == '@')
            {
                ri = i;
                rj = j;
            }
        }
    }

    // std::cout << "Robot at i=" << ri << " j=" << rj << std::endl;

    for (const auto action : actions)
    {
        int di = 0, dj = 0;

        if (action == '^')
            di = -1;
        else if (action == '>')
            dj = 1;
        else if (action == 'v')
            di = 1;
        else if (action == '<')
            dj = -1;
        else
            continue;

        int i = ri + di, j = rj + dj;

        while (map[i][j] == 'O')
        {
            i += di;
            j += dj;
        }

        if (map[i][j] == '.')
        {
            map[ri][rj] = '.';
            map[i][j] = 'O';
            ri += di;
            rj += dj;
            map[ri][rj] = '@';
        }
    }

    // for (int i = 0; i < height; ++i)
    // {
    //     std::cout << map[i] << "\n";
    // }

    std::cout << "Task 1: " << gps_sum(map, 'O') << std::endl;

    map.clear();

    for (const auto &line : original_map)
    {
        std::string expanded_line;

        for (const auto c : line)
        {
            if (c == '#')
                expanded_line += "##";
            if (c == 'O')
                expanded_line += "[]";
            if (c == '.')
                expanded_line += "..";
            if (c == '@')
                expanded_line += "@.";
        }

        map.emplace_back(std::move(expanded_line));
    }

    width = map[0].length();

    // for (const auto &line : map)
    // {
    //     std::cout << line << std::endl;
    // }

    for (int i = 0; i < height; ++i)
    {
        for (int j = 0; j < width; ++j)
        {
            if (map[i][j] == '@')
            {
                ri = i;
                rj = j;
            }
        }
    }

    // std::cout << "Robot at i=" << ri << " j=" << rj << std::endl;

    for (const auto action : actions)
    {
        int di = 0, dj = 0;

        if (action == '^')
            di = -1;
        else if (action == '>')
            dj = 1;
        else if (action == 'v')
            di = 1;
        else if (action == '<')
            dj = -1;
        else
            continue;

        int i = ri + di, j = rj + dj;

        if (map[i][j] == '.')
        {
            map[ri][rj] = '.';
            map[i][j] = '@';

            ri = i;
            rj = j;
        }
        else if (map[i][j] == '#')
            continue;
        else
        {
            const auto headj = map[i][j] == ']' ? j - 1 : j;

            // std::cout << "Starting recursive box search at (" << i << "," << headj << ")" << std::endl;

            const auto moved = boxMove(i, headj, action, map);

            if (moved.possible)
            {
                map[ri][rj] = '.';

                for (const auto [bi, bj] : moved.boxes)
                {
                    map[bi][bj] = '.';
                    map[bi][bj + 1] = '.';
                }

                for (const auto [bi, bj] : moved.boxes)
                {
                    map[bi + di][bj + dj] = '[';
                    map[bi + di][bj + dj + 1] = ']';
                }

                map[i][j] = '@';

                ri = i;
                rj = j;
            }
        }

        // for (const auto &line : map)
        // {
        //     std::cout << line << std::endl;
        // }
        // std::cout << std::endl;
    }

    std::cout << "Task 2: " << gps_sum(map, '[') << std::endl;
}
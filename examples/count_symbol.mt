X = ('b' .. 'z').to_a + ['*', '|']
Y = ('a' .. 'z').to_a + ['*', '|'] 
Z = ('b' .. 'z').to_a + ['β']

#############################################
# Counting number of 'a' symbols in the query
#############################################

# add *| at the end, denoting 0 matches
0 Y - 0 Y >
0 ~ - 1 * >
1 * - 1 * >
1 ~ - 2 | <

# go back to the beginning of query
2 Y - 2 Y <
2 ~ - 3 ~ >

# try to find next a
3 Z - 3 Z >

# change a to β to exclude it from next iteration
3 a - 4 β >
3 * - 5 * .

# if a is found, add | and go back
4 Y - 4 Y >
4 ~ - 6 | <
6 Y - 6 Y <
6 β - 6 β <
6 ~ - 3 ~ >

# no more a in the query, change all β back to a
5 X - 5 X <
5 β - 5 a <

Simple emulator of Turing machine
=================================

## Syntax of rules file

### Shortcuts
```
[Symbol] = [Ruby expression, either String or an Array of characters]
```

### Rules 
```
[Integer] [Symbol] -> [Integer] [Symbol] [Action]
```
(if both symbols are shortcuts, they are to be the same)

### Comments
```
# currently, each comment must be on its own line
```

## Examples

### Replacing 0 with 1, and vice versa

```
0 0 - 0 1 >
0 1 - 0 0 >
```

### Replacing β with α

```
G = ('α' .. 'ω').to_a - ['β']
0 G - 0 G >
0 β - 0 α >
```


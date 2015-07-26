## Strings and Characters

- 初始化空字符串
```
var emptyString = ""               // empty string literal
var anotherEmptyString = String()  // initializer syntax
```

- isEmpty属性
```
if emptyString.isEmpty {
    println("Nothing to see here")
}
```

- String是Character的集合，可以用for-in来遍历

- 声明字符; 字符数组可以转换为字符串

```
let exclamationMark: Character = "!"

let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
println(catString)
```

- 字符串用`+`连接，字符串用`append()`添加字符

```
let exclamationMark: Character = "!"
welcome.append(exclamationMark) // welcome now equals "hello there!"
```

- String Interpolation. 字符串插入

```
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message is "3 times 2.5 is 7.5"
```

- 特殊字符的表示

>The escaped special characters \0 (null character), \\ (backslash), \t (horizontal tab), \n (line feed), \r (carriage return), \" (double quote) and \' (single quote)

>An arbitrary Unicode scalar, written as \u{n}, where n is a 1–8 digit hexadecimal number with a value equal to a valid Unicode code point

```swift
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imagination is more important than knowledge" - Einstein
let dollarSign = "\u{24}"        // $,  Unicode scalar U+0024
let blackHeart = "\u{2665}"      // ♥,  Unicode scalar U+2665
let sparklingHeart = "\u{1F496}" // 💖, Unicode scalar U+1F496
```

- Extended Grapheme Clusters; An extended grapheme cluster is a sequence of one or more Unicode scalars that (when combined) produce a single human-readable character. 增强字符集是一个或多个Unicode标量组合而成的人类可读的字符。下面例子是一个可读字符的两种表示方法，一个只有一个标量，一个有两个组成。在swift中都可被认为是字符类型。

```
let eAcute: Character = "\u{E9}"                         // é
let combinedEAcute: Character = "\u{65}\u{301}"          // e followed by ́
// eAcute is é, combinedEAcute is é
```

- 字符计数. 由于swift使用了Extended Grapheme Clusters作为字符识别的单位，意味着对字符串添加
内容不一定会增加count()的返回长度,例如下面：

```
var word = "cafe"
println("the number of characters in \(word) is \(count(word))")
// prints "the number of characters in cafe is 4"

word += "\u{301}"    // COMBINING ACUTE ACCENT, U+0301

println("the number of characters in \(word) is \(count(word))")
// prints "the number of characters in café is 4"
```

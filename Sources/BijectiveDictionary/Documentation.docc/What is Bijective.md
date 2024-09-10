# What does 'Bijective' mean? 

Learn how bijection affects the behavior of `BijectiveDictionary`. 

## Overview
[Bijection](https://en.wikipedia.org/wiki/Bijection) is the property of having one-to-one correspondence between two sets.  

![](Bijection.svg) 

From this definition we can see that ``BijectiveDictionary`` has these important characteristics:
1. Every left value is **unique** (just like a `Dictionary` key).
2. Every right value is **also unique** (unlike a `Dictionary` value).
3. Every left value has **one and only one** corresponding right value.
4. Every right value has **one and only one** corresponding left value.

Just like a `Set`, all key-value pairs in a `BijectiveDictionary` are unique and unordered. 

If you do not want these properties for your particular use case, then `BijectiveDictionary` is not the right tool for the job.

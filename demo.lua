x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))

X = 0+
Y = 0+
Z = 0+

x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))

X = 0+.0+
Y = 0+.0+
Z = 0+.0+

x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))

X =  0+.0+
Y = -0+.0+
Z = -0+.0+

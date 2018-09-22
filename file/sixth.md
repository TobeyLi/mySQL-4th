	创建计算字段
1.为什么要引入计算字段？
	存储在数据库表中的数据一般不是应用程序所需要的格式，所以我们需要直接从数据库中检索出转换、计算或者格式化过的数据，这就是计算字段作用的位置了。
	计算字段并不实际存在于数据库表中，计算字段是运行时在SELECT语句内创建的。
2.拼接字段
	拼接（concatenate）:将值联结到一起（将一个值附加到另外一个值）构成单个值。
	为了说明如何使用计算字段，我们来创建一个由两列组成的标题：此报表需要一个值，而表中数据存储在两个列vend_name和vend_country中，此外，需要用括号将vend_country
	括起来，这些东西都没有存储在数据库表中，我们如何创建这个组合键呢？
	解决办法就是将这两个列拼接起来。在MySQL里面，必须是使用函数：Concat（列名1，列名2...）
	eg.	SELECT Concat(vend_name,'(',vend_country,')') FROM Vendors ORDER BY vend_name;
	+----------------------------------------+
	| Concat(vend_name,'(',vend_country,')') |
	+----------------------------------------+
	| Bear Emporium(USA)                     |
	| Bears R Us(USA)                        |
	| Doll House Inc.(USA)                   |
	| Fun and Games(England)                 |
	| Furball Inc.(USA)                      |
	| Jouets et ours(France)                 |
	+----------------------------------------+
	解释：上面的SELECT语句拼接了一下元素：
	1）存储在vend_name 列中的名字；
	2）一个左圆括号的字符串；
	3）存储在vend_country列中的国家；
	4）包含一个右圆括号的字符串

3.使用别名
	从前面的输出可以看出，SELECT语句可以很好的拼接地址字段，但是这个新的一列的名字是什么呢？
	实际上这个列并没有名字，它是一个值。如果仅仅是查看一下结果，这样做就可以了，但是这个未命名的列不能用于客户端应用中。
	为了解决这个问题，SQL支持列别名，别名用AS关键字赋予。
	eg.	SELECT Concat(vend_name,'(',vend_country,')') AS vend_title FROM Vendors ORDER BY vend_name;
	+------------------------+
	| vend_title             |
	+------------------------+
	| Bear Emporium(USA)     |
	| Bears R Us(USA)        |
	| Doll House Inc.(USA)   |
	| Fun and Games(England) |
	| Furball Inc.(USA)      |
	| Jouets et ours(France) |
	+------------------------+
	但是在MySQL中：SELECT vend_title FROM Vendors ORDER BY vend_name;这条语句会报错，即不存在这一列。

4.执行算术运算
	计算字段的另外一个常见的用途是对检索出的数据进行算术运算。
	如：SELECT prod_id,quantity,item_price FROM OrderItems WHERE order_num=20008;
	+---------+----------+------------+
	| prod_id | quantity | item_price |
	+---------+----------+------------+
	| RGAN01  |        5 |       4.99 |
	| BR03    |        5 |      11.99 |
	| BNBG01  |       10 |       3.49 |
	| BNBG02  |       10 |       3.49 |
	| BNBG03  |       10 |       3.49 |
	+---------+----------+------------+
	查询出来这个表之后，我们想知道每件物品的总价是多少，这样便于直接统计，观察数据，那么可以插入以下计算字段：
	SELECT prod_id,quantity,item_price,quantity*item_price AS expanded_price FROM OrderItems WHERE order_num=20008;
	+---------+----------+------------+----------------+
	| prod_id | quantity | item_price | expanded_price |
	+---------+----------+------------+----------------+
	| RGAN01  |        5 |       4.99 |          24.95 |
	| BR03    |        5 |      11.99 |          59.95 |
	| BNBG01  |       10 |       3.49 |          34.90 |
	| BNBG02  |       10 |       3.49 |          34.90 |
	| BNBG03  |       10 |       3.49 |          34.90 |
	+---------+----------+------------+----------------+
	这样就对统计出来的结果一目了然了。
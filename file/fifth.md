	本文主要是讲解用通配符进行过滤
1.通配符
	用来匹配值得一部分的特殊字符。利用通配符，可以创建特定数据的搜索模式。比如说你想找出名称中含有bean bag 的所有产品，但是你记不清楚其全名是什么，那么在这个时候
	可以利用通配符来进行操作，来获取特定的记录。
	注意：通配符搜索只能用于文本字段（字符串）,非文本数据类型字段不能使用通配符搜索。
	为了在搜索子句中使用通配符，必须使用LIKE操作符。
2.说明部分（若存在不清楚的部分可以跳过再回来看）------>使用通配符的技巧
	a）不要过度使用通配符：如果其他操作符能够达到相同的目的，应该使用其他操作符；
	b）在确定使用通配符的时候，也尽量不要把它们用在搜索模式的开始处。把通配符放在开始处，搜索起来是最慢的；
	c）一定要仔细确定通配符的位置，如果放错地方，可能不会返回想要的数据。
		

3.百分号（%）通配符
	在搜索串中，%表示任何字符出现任意次数，例如，为了找到以Fish开头的产品，可以使用如下语句：
	SELECT prod_id,prod_name FROM Products WHERE prod_name LIKE 'FISH%';
	+---------+-------------------+
	| prod_id | prod_name         |
	+---------+-------------------+
	| BNBG01  | Fish bean bag toy |
	+---------+-------------------+
	注意：通配符可在搜索模式中的任意位置使用，并且可以使用多个通配符
	eg,SELECT prod_id,prod_name FROM Products WHERE prod_name LIKE '%bean bag%';
	+---------+---------------------+
	| prod_id | prod_name           |
	+---------+---------------------+
	| BNBG01  | Fish bean bag toy   |
	| BNBG02  | Bird bean bag toy   |
	| BNBG03  | Rabbit bean bag toy |
	+---------+---------------------+
	
	再比如：要查找以F开头，以y结尾的所有产品：
	SELECT prod_id,prod_name FROM Products WHERE prod_name LIKE 'F%y';
	+---------+-------------------+
	| prod_id | prod_name         |
	+---------+-------------------+
	| BNBG01  | Fish bean bag toy |
	+---------+-------------------+
	
	注意：貌似通配符%可以匹配任何东西，但是有个例外，那就是NULL，即子句WHERE prod_name LIKE '%'，不会匹配产品名称为NULL的行

4.下划线（_）通配符
	eg. SELECT prod_id,prod_name FROM Products WHERE prod_name LIKE '__ inch teddy bear';      --->注意此处有两个下划线，所以匹配的是两个字符
	+---------+--------------------+
	| prod_id | prod_name          |
	+---------+--------------------+
	| BR02    | 12 inch teddy bear |
	| BR03    | 18 inch teddy bear |
	+---------+--------------------+
	
	eg.	SELECT prod_id,prod_name FROM Products WHERE prod_name LIKE '% inch teddy bear';
	+---------+--------------------+
	| prod_id | prod_name          |
	+---------+--------------------+
	| BR01    | 8 inch teddy bear  |
	| BR02    | 12 inch teddy bear |
	| BR03    | 18 inch teddy bear |
	+---------+--------------------+
	以上的操作说明一个问题：下划线操作符 _ 总是能刚好匹配到一个字符，不能多也不能少，%则可以匹配多个字符
	
5.方括号([])通配符   
	方括号通配符用来指定一个字符集，它必须匹配指定位置（通配符的位置）的一个字符。
	例如：找出所有名字以J或者以M起头的联系人，则查询语句如下：
	SELECT cust_contact FROM Customers WHERE cust_contact LIKE '[JM]%';
	
	注意方括号[] 匹配符
	目前只有Access和SQL Server支持这种格式，而在MySQL中，方括号[]表示正则模式  
	
	什么是正则模式---->看完这本书再来讨论
	这一课主要是讲解SQL的聚集函数，以及如何利用它们汇总数据。
1.SQL聚集函数  --->对某些行运行的函数，计算并返回一个值。
	通常情况下，我们需要的是汇总数据而不是把它们实际检索出来，所以SQL提供了专门的函数

	1.1	AVG()函数：返回某列的平均值。
		eg.	SELECT AVG(prod_price) AS avg_price FROM Products;
			+-----------+
			| avg_price |
			+-----------+
			|  6.823333 |
			+-----------+
		AVG() 也可以来确定特定列或者行的平均值。
		eg.	SELECT AVG(prod_price) AS avg_price FROM Products WHERE vend_id='DLL01';
			+-----------+
			| avg_price |
			+-----------+
			|  3.865000 |
			+-----------+
		说明：AVG()	函数忽略列值为NULL的行
		
	1.2	COUNT()函数： 返回某列的行数
		COUNT()函数进行计数，可利用COUNT()确定表中行的数目或符合特定条件的行的数目。
		COUNT() 函数存在两种使用方式：
			a）使用COUNT(*)对表中的行的数目进行计数，不管表列中包含的是空值（NULL）还是非空值。
			b）使用COUNT(column)对特定列中具有值的行进行计数，忽略NULL值。
		
		eg.下面的例子返回Customers表中顾客的总数：
		SELECT COUNT(*) AS num_cust FROM Customers;
			+----------+
			| num_cust |
			+----------+
			|        5 |
			+----------+
		在这个操作中，利用COUNT(*) 对所有行计数。不管行中各列有什么值。
		
		下面的例子只对具有电子邮件地址的客户计数：
		SELECT COUNT(cust_email) AS num_cust FROM Customers;
			+----------+
			| num_cust |
			+----------+
			|        3 |
			+----------+
		cust_email 的计数为3，表示总共5个顾客中有3个存在电子邮件。这个是不忽略NULL的。
		
	1.3	MAX() 函数：返回指定列的最大值
		eg. SELECT MAX(prod_price) AS max_price FROM Products;
			+-----------+
			| max_price |
			+-----------+
			|     11.99 |
			+-----------+
		说明：MAX()函数 忽略列值为NULL的行。
		
	1.4	MIN() 函数：返回指定列的最小值。
	
	1.5	SUM() 函数：返回指定列的和（总计）。
		eg.	SELECT SUM(quantity) AS items_ordered FROM OrderItems WHERE order_num=20005;
			+---------------+
			| items_ordered |
			+---------------+
			|           200 |
			+---------------+
		同样的，SUM() 也可以用来合计计算值。
		eg.	SELECT SUM(quantity*item_price) AS total_price FROM OrderItems WHERE order_num=20005;
			+-------------+
			| total_price |
			+-------------+
			|     1648.00 |
			+-------------+
		说明：SUM() 函数忽略列值为NULL的行。

2.聚焦不同的值
	以上的五个聚集函数都可以如下使用；
		a)	对所有的行执行，指定ALL参数或不指定参数（因为ALL是默认行为）
		b)	只包含不同的值，指定DISTINCT参数
		eg.	SELECT AVG(DISTINCT prod_price) AS avg_price FROM Products WHERE vend_id='DLL01';
			+-----------+
			| avg_price |
			+-----------+
			|  4.240000 |
			+-----------+
	在这条语句中，平均值只是参考了各个不同的价格。
		注意：如果指定列名，则DISTINCT 只能用于COUNT()，DISTINCT 不能使用COUNT(*),同样的，DISTINCT必须使用列名，不能用于计算或者表达式。
	
3.组合聚集函数
	在实际的情况下，SELECT 语句可根据需要包含多个聚集函数：
	eg.	SELECT COUNT(*) AS num_items,MIN(prod_price) AS price_min,MAX(prod_price) AS price_max,AVG(prod_price) AS price_avg FROM Products;
		+-----------+-----------+-----------+-----------+
		| num_items | price_min | price_max | price_avg |
		+-----------+-----------+-----------+-----------+
		|         9 |      3.49 |     11.99 |  6.823333 |
		+-----------+-----------+-----------+-----------+
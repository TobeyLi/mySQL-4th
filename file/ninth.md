	分组数据
1.数据分组
	SELECT COUNT(*) AS num_prods FROM Products WHERE vend_id='DLL01';
		+-----------+
		| num_prods |
		+-----------+
		|         4 |
		+-----------+
	这一句是统计供应商为DLL01所提供的产品数目，但是如果我们想返回每个供应商提供的产品的数目，该怎么办？
	那么就必须采用一种新的方式来解决，即分组：使用分组可以将数据分为多个逻辑组，对每个组进行聚集运算。

2.创建分组  --->GROUP BY子句建立
	eg.	SELECT vend_id,COUNT(*) AS num_prods FROM Products GROUP BY vend_id;
		+---------+-----------+
		| vend_id | num_prods |
		+---------+-----------+
		| BRS01   |         3 |
		| DLL01   |         4 |
		| FNG01   |         2 |
		+---------+-----------+
		说明：GROUP BY 子句指示DBMS按照vend_id排序并分组数据。通过输出可以看出：供应商BRS01有3个产品，供应商DLL01有4个产品，FNG01有2个产品。
		GROUP BY 子句指示DBMS分组数据，然后对每个组而不是整个结果集进行聚集。在使用GROUP BY子句之前，有一些重要的规定:
		a)	GROUP BY 子句可以包含任意数目的列，因而可以对分组进行嵌套，更细致的进行数据分组；
		b)	在建立分组时，指定的所有列都一起计算；
		c)	GROUP BY 子句中列出的每一列都必须是检索列或有效的表达式（但不能是聚集函数），如果在SELECT 中使用表达式，则必须在GROUP BY子句中指定
		相同的表达式，不能使用别名；
		d)	GROUP BY 子句必须出现在WHERE 子句之后，ORDER BY 子句之前；
		f)	如果分组列中包含NULL值的行，则所有的NULL将作为一个分组返回。

3.过滤分组
	除了能用GROUP BY 分组数据外，SQL还允许过滤分组，规定包含哪些分组，排除哪些分组。
	例如：我们需要列出至少有两个订单的所有顾客。为此，必须基于完整的分组而不是个别的行进行过滤。
	能否使用WHERE语句来过滤呢？
	答案是否定的，因为WHERE过滤的是指定的行而不是分组，事实上，WHERE没有分组的概念。那么怎么来解决这个问题嗯？为此SQL提供了另外一个子句：HAVING
	其主要作用是过滤分组。
	eg.	SELECT cust_id,COUNT(*) AS Orders FROM Orders GROUP BY cust_id HAVING COUNT(*)>=2;
		+------------+--------+
		| cust_id    | Orders |
		+------------+--------+
		| 1000000001 |      2 |
		+------------+--------+
	HAVING 与 WHERE 的差别之一：WHERE 在数据分组之前进行过滤，HAVING 在数组分组后进行过滤。
	
	WHERE和HAVING同时使用的例子：
	eg.	SELECT vend_id,COUNT(*) AS num_prods FROM Products WHERE prod_price>=4 GROUP BY vend_id HAVING COUNT(*)>=2;
		+---------+-----------+
		| vend_id | num_prods |
		+---------+-----------+
		| BRS01   |         3 |
		| FNG01   |         2 |
		+---------+-----------+
	说明：首先WHERE过滤了所有prod_price 至少为4的行，然后按vend_id分组数据，HAVING子句过滤计数为2或者2以上的分组。
	
	假如去掉WHERE子句：
	eg.	SELECT vend_id,COUNT(*) AS num_prods FROM Products GROUP BY vend_id HAVING COUNT(*)>=2;
		+---------+-----------+
		| vend_id | num_prods |
		+---------+-----------+
		| BRS01   |         3 |
		| DLL01   |         4 |
		| FNG01   |         2 |
		+---------+-----------+
	说明供应商DLL01所销售的产品都在4美元以下
	
	
	说明：HAVING 和WHERE 非常相似，如果不指定GROUP BY，则大多是DBMS会同等对待他们。不过，使用HAVING时应结合GROUP BY语句，而WHERE子句用于标准的行级过滤。
	
4.分组和排序（ORDER BY和GROUP BY）----->分组是分组，排序是排序。
	一般在使用GROUP BY子句时，应该也给出ORDER BY子句，这是保证数据正确排序的唯一办法。
	eg.	SELECT order_num,COUNT(*) AS items FROM OrderItems GROUP BY order_num HAVING COUNT(*)>=3 ORDER BY items,order_num;	
		+-----------+-------+
		| order_num | items |
		+-----------+-------+
		|     20006 |     3 |
		|     20009 |     3 |
		|     20007 |     5 |
		|     20008 |     5 |
		+-----------+-------+
		
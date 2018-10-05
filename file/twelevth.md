	组合查询（UNION）
1.什么叫组合查询？
	SQL允许执行多个查询（多条SELECT语句）,并将结果作为一个查询结果集返回。这些组合查询通常称为并（UNION）或者复合查询（compound query）.
2.哪些情况需要用到组合查询？
	1)在一个查询中从不同的表返回结构数据;
	2)对一个表执行多个查询，按一个查询返回数据。
3.使用UNION 举例
	假如需要Illinois、Indiana、Michigan	等美国几个州的所有顾客的报表，还想包括不管位于哪个州的所有的Fun4All。
	
	解决方式：先假设采用单条语句：
	SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_state IN ('IL','IN','MI');
		+---------------+--------------+-----------------------+
		| cust_name     | cust_contact | cust_email            |
		+---------------+--------------+-----------------------+
		| Village Toys  | John Smith   | sales@villagetoys.com |
		| Fun4All       | Jim Jones    | jjones@fun4all.com    |
		| The Toy Store | Kim Howard   | NULL                  |
		+---------------+--------------+-----------------------+
	再看第二个问题的解决方案：
	SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_name='Fun4All';
		+-----------+--------------------+-----------------------+
		| cust_name | cust_contact       | cust_email            |
		+-----------+--------------------+-----------------------+
		| Fun4All   | Jim Jones          | jjones@fun4all.com    |
		| Fun4All   | Denise L. Stephens | dstephens@fun4all.com |
		+-----------+--------------------+-----------------------+
	那么再用UNION将它们组合起来即可：
	SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_state IN ('IL','IN','MI') 
	UNION SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_name='Fun4All';
		+---------------+--------------------+-----------------------+
		| cust_name     | cust_contact       | cust_email            |
		+---------------+--------------------+-----------------------+
		| Village Toys  | John Smith         | sales@villagetoys.com |
		| Fun4All       | Jim Jones          | jjones@fun4all.com    |
		| The Toy Store | Kim Howard         | NULL                  |
		| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |
		+---------------+--------------------+-----------------------+
	可以看出，这样即找到了所有满足条件的结果。
	
	同样的，如果改写这条语句，使用OR关键字，那么同样也可以得到相同的结果。
	SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_state IN ('IL','IN','MI') OR cust_name='Fun4All';
	
4.使用UNION的规则(注意事项)
	1)UNION必须由两条或者两条以上的SELECT 语句构成，语句之间用关键字UNION分割;
	2)UNION中的每个查询必须包含相同的列、表达式或聚集函数（不过，每个列不需要以相同的次序列出）
	3)列数据类型必须兼容：类型不必完全相同，但必须是DBMS可以隐含转换的类型（例如：不同的数值类型或者不同的日期类型）
5.包含或者取消重复的行
	在上面的UNION例子可以看出，UNION关键字自动取消了重复的行。当要返回所有的匹配的行，可使用UNION ALL 而不是UNION。
	eg.	SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_state IN ('IL','IN','MI') 
	UNION ALL SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_name='Fun4All';
		+---------------+--------------------+-----------------------+
		| cust_name     | cust_contact       | cust_email            |
		+---------------+--------------------+-----------------------+
		| Village Toys  | John Smith         | sales@villagetoys.com |
		| Fun4All       | Jim Jones          | jjones@fun4all.com    |
		| The Toy Store | Kim Howard         | NULL                  |
		| Fun4All       | Jim Jones          | jjones@fun4all.com    |
		| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |
		+---------------+--------------------+-----------------------+
	上面的查询结果包含了两个相同的记录。
6.对组合查询结果排序
	---->在用UNION组合查询时，只能使用一条ORDER BY 语句，它必须位于最后一条的SELECT 语句之后。
	 SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_state IN ('IL','IN','MI')
     UNION SELECT cust_name,cust_contact,cust_email FROM Customers WHERE cust_name='Fun4All'
     ORDER BY cust_name,cust_contact;
		+---------------+--------------------+-----------------------+
		| cust_name     | cust_contact       | cust_email            |
		+---------------+--------------------+-----------------------+
		| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |
		| Fun4All       | Jim Jones          | jjones@fun4all.com    |
		| The Toy Store | Kim Howard         | NULL                  |
		| Village Toys  | John Smith         | sales@villagetoys.com |
		+---------------+--------------------+-----------------------+
		
下面说的两种UNION，MySQL中不支持，当做了解SQL：
	1)EXCEPT:可用来检索只在第一个表中存在而在第二个表中不存在的行；
	2)INTERSECT：可用来检索两个表中都存在的行。
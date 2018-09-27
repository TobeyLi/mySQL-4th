	使用子查询（按照要求，将多个WHERE子句组合在一起查询）
1.子查询
	任何SQL语句都是查询。但是此术语一般指SELECT 语句。子查询是指嵌套在其他查询中的查询。
2.利用子查询进行过滤
	首先说明：订单存储在两个表中。每个订单包含订单编号、客户ID、订单日期，在Orders表中存储为一行。各订单的物品存储在相关的OrderItems表中。Orders表不存储顾客信息
	只存储顾客ID。顾客的实际信息存储在Customers表中。
	那么现在需要列出订购物品RGAN01的所有顾客，应该怎么检索呢？下面列出检索过程：
		1)检索包含物品RGAN01的所有订单编号；
		2)检索具有前一步骤列出的订单编号的所有顾客的ID；
		3)检索前一步骤返回的所有顾客ID的顾客信息。
	那么接下来可以分段解决：
	求解第一个问题：
	SELECT order_num FROM OrderItems WHERE prod_id='RGAN01';
		+-----------+
		| order_num |
		+-----------+
		|     20007 |
		|     20008 |
		+-----------+
	再来计算第二步：检索出与订单20007和20008相关的客户的ID：
	SELECT cust_id FROM Orders WHERE order_num IN (20007,20008);
		+------------+
		| cust_id    |
		+------------+
		| 1000000004 |
		| 1000000005 |
		+------------+
	那么这就是顾客的ID信息。于是，我们可以把这两条SELECT语句组合在一起，查看一下，是不是想要的结果：
	SELECT cust_id FROM Orders WHERE order_num IN (SELECT order_num FROM OrderItems WHERE prod_id='RGAN01');
		+------------+
		| cust_id    |
		+------------+
		| 1000000004 |
		| 1000000005 |
		+------------+
	和上面的结果一致，说明组合在一起与分开查询的结果是一样的。在SELECT 语句中，子查询总是从内向外处理的。
	在得到了客户的ID后，那么我们需要返回客户的所有信息
	SELECT * FROM Customers WHERE cust_id IN ('1000000004','1000000005');
		+------------+---------------+---------------------+-----------+------------+----------+--------------+--------------------+-----------------------+
		| cust_id    | cust_name     | cust_address        | cust_city | cust_state | cust_zip | cust_country | cust_contact       | cust_email            |
		+------------+---------------+---------------------+-----------+------------+----------+--------------+--------------------+-----------------------+
		| 1000000004 | Fun4All       | 829 Riverside Drive | Phoenix   | AZ         | 88888    | USA          | Denise L. Stephens | dstephens@fun4all.com |
		| 1000000005 | The Toy Store | 4545 53rd Street    | Chicago   | IL         | 54545    | USA          | Kim Howard         | NULL                  |
		+------------+---------------+---------------------+-----------+------------+----------+--------------+--------------------+-----------------------+
	这样即完成了所有的要求查询的内容，那么可以用一条子查询语句来解决问题：
	SELECT * FROM Customers WHERE cust_id IN (SELECT cust_id FROM Orders WHERE order_num IN (SELECT order_num FROM OrderItems WHERE prod_id='RGAN01'));
	可以返回同样的结果。
	这即是子查询的引用。

3.作为计算字段使用子查询
	假如需要显示Customers表中每个顾客的订单总数。订单与相应的顾客ID存储在Orders表中。
	那么执行这个操作，需要遵循以下的步骤：
	1)从Customers 表中检索顾客列表；
	2)对于检索出的每个顾客，统计其在Orders表中的订单数目。
	那么 可以采用子查询来解决这个问题：
	eg.	SELECT cust_name,cust_state,(SELECT COUNT(*) FROM Orders WHERE Orders.cust_id=Customers.cust_id) AS orders FROM Customers ORDER BY cust_name;
		+---------------+------------+--------+
		| cust_name     | cust_state | orders |
		+---------------+------------+--------+
		| Fun4All       | IN         |      1 |
		| Fun4All       | AZ         |      1 |
		| Kids Place    | OH         |      0 |
		| The Toy Store | IL         |      1 |
		| Village Toys  | MI         |      2 |
		+---------------+------------+--------+
	其中oders列作为计算字段，该子查询对检索出的每个顾客执行一次。
	
	个人小结：其实就是按照要求一步一步的分析，得到正确的结果，最后将多个SELECT语句组合在一起即完成了子查询。
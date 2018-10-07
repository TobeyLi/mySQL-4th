	使用视图
1.什么是视图？
	视图是虚拟的表，与包含数据的表不一样，视图只包含使用时动态检索数据的查询。
	下面通过举例来说明：
	比如说我们之前所举的例子：需要查找订购了某种产品的顾客，
	eg.	SELECT cust_name,cust_contact FROM Customers,Orders,OrderItems WHERE Customers.cust_id=Orders.cust_id
		AND OrderItems.order_num=Orders.order_num AND prod_id='RGAN01';
	
	当需要检索出其他产品(或多个产品)的相同数据，必须修改最后的WHERE子句。那么为了简化，我们可以把整个查询包装成一个名为ProductCustomers的虚拟表，那么
	同样的，检索出相同的数据则可以使用如下语句：
	SELECT cust_name,cust_contact FROM ProductCustomers WHERE prod_id='RGAN01';
2.为什么需要使用视图？
	1)重用SQL语句；
	2)简化复杂的SQL操作。在编写查询后，可以方便的重用它而不必知道其基本查询细节。
	3)使用表的一部分而不是整个表
	4)保护数据。可以授权用户访问特定的表的部分。
	5)更改数据的格式和表示。视图可以返回与底层表的表示和格式不同的数据。
	
	注意：视图仅仅是用来查看存储在别处数据的一种设施。

3.使用视图举例
	语法：CREATE VIEW ProductCustomers AS SELECT cust_name,cust_contact,prod_id FROM Customers,Orders,OrderItems WHERE Customers.cust_id=Orders.cust_id
		AND OrderItems.order_num=Orders.order_num;
		
		那么接下来查询即可使用如下语句；SELECT cust_name,cust_contact FROM ProductCustomers WHERE prod_id='RGAN01';
			+---------------+--------------------+
			| cust_name     | cust_contact       |
			+---------------+--------------------+
			| Fun4All       | Denise L. Stephens |
			| The Toy Store | Kim Howard         |
			+---------------+--------------------+
		
		这样即是正确的得到了结果。可以看到视图极大的简化了复杂SQL语句的使用，利用视图，可一次性编写基础的SQL，然后根据需要，多次使用。

4.小结
	视图本质就是对查询的一个封装。可以封装以后所想重用的SQL语句。
		
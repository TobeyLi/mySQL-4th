联结表
1.为什么要建立关系表？
	若所有的信息都放在一个表中，会产生冗余。同时，若某个表的信息发生变化，只需要去更改那个表的相关内容即可，不用再去操作其他的表。
	这个做的效果是耦合性较低。同时，由于数据不重复，数据显然是一致的，使得处理数据和生成报表更加简单。
2.为什么要使用联结？
	从上面的来看，若把数据分解为多个表进行存储，有许许多多的好处。但是如果数据存储在多个表中，怎样用一条SELECT 语句就检索出数据呢?
	那么就是需要采用联结技术，使用特殊的语法，可以联结多个表返回一组输出，联结在运行时关联表中正确的行。
3.创建联结
	创建联结比较简单，指定要连接的所有表以及关联他们的方式即可。
	eg.	SELECT vend_name,prod_id,prod_price FROM Vendors,Products WHERE Vendors.vend_id=Products.vend_id;
		+-----------------+---------+------------+
		| vend_name       | prod_id | prod_price |
		+-----------------+---------+------------+
		| Bears R Us      | BR01    |       5.99 |
		| Bears R Us      | BR02    |       8.99 |
		| Bears R Us      | BR03    |      11.99 |
		| Doll House Inc. | BNBG01  |       3.49 |
		| Doll House Inc. | BNBG02  |       3.49 |
		| Doll House Inc. | BNBG03  |       3.49 |
		| Doll House Inc. | RGAN01  |       4.99 |
		| Fun and Games   | RYL01   |       9.49 |
		| Fun and Games   | RYL02   |       9.49 |
		+-----------------+---------+------------+
	说明：在这里，vend_name 来自于Vendors 表，prod_id,prod_price来自于Products 表。从输出可以看出，这条SELECT 语句返回了两个不同表中的数据。
	在进行联结时，实际上要做的是将第一个表中的每一行与第二个表中的每一行配对，WHERE子句作为过滤条件，只包含那些匹配给定条件（这里是联结条件的行）。
	假如不存在WHERE子句 第一个表中的每一行将与第二个表中的每一行配对，而不管它们逻辑上是否能够配在一起。
	
	笛卡尔积	---> 由没有联结条件的表关系返回的结果为笛卡尔积。检索出的行的数目将是第一个表中的行数乘以第二个表中的行数。
	有时，返回笛卡尔积的联结，也称为叉联结。
	
	eg.	SELECT vend_name,prod_id,prod_price FROM Vendors,Products;			-----> 结果太长了，自己实现的时候看一下。
	这里返回的数据用每个供应商匹配了每个产品，包括了供应商不正确的产品（即是供应商根本就没有产品）
	
	所以，要保证所有的联结都要有WHERE子句，否则DBMS 将返回比想要的数据多得多的数据。

4.内联结
	目前为止使用的联结都是称为等值联结，它基于两个表之间的相等测试。这种联结也称为内联结（inner join），这种实现也可以基于以下的语法：
	eg.	SELECT vend_name,prod_name,prod_price FROM Vendors INNER JOIN Products ON Vendors.vend_id=Products.vend_id;
		+-----------------+---------------------+------------+
		| vend_name       | prod_name           | prod_price |
		+-----------------+---------------------+------------+
		| Doll House Inc. | Fish bean bag toy   |       3.49 |
		| Doll House Inc. | Bird bean bag toy   |       3.49 |
		| Doll House Inc. | Rabbit bean bag toy |       3.49 |
		| Bears R Us      | 8 inch teddy bear   |       5.99 |
		| Bears R Us      | 12 inch teddy bear  |       8.99 |
		| Bears R Us      | 18 inch teddy bear  |      11.99 |
		| Doll House Inc. | Raggedy Ann         |       4.99 |
		| Fun and Games   | King doll           |       9.49 |
		| Fun and Games   | Queen doll          |       9.49 |
		+-----------------+---------------------+------------+
	在使用这种语法时，联结条件用特定的ON子句而不是WHERE 子句给出。
5.联结多个表
	SQL不限制一条SELECT语句中可以联结的表的数目。创建联结表的基本规则也相同。
	eg.	SELECT prod_name,vend_name,prod_price,quantity FROM OrderItems,Products,Vendors WHERE Products.vend_id=Vendors.vend_id 
		AND	OrderItems.prod_id=Products.prod_id AND order_num=20007;
		+---------------------+-----------------+------------+----------+
		| prod_name           | vend_name       | prod_price | quantity |
		+---------------------+-----------------+------------+----------+
		| 18 inch teddy bear  | Bears R Us      |      11.99 |       50 |
		| Fish bean bag toy   | Doll House Inc. |       3.49 |      100 |
		| Bird bean bag toy   | Doll House Inc. |       3.49 |      100 |
		| Rabbit bean bag toy | Doll House Inc. |       3.49 |      100 |
		| Raggedy Ann         | Doll House Inc. |       4.99 |       50 |
		+---------------------+-----------------+------------+----------+
	说明：这个例子显示订单200007中的物品。订单物品存储在OrderItems表中。每个产品按其产品ID存储，它引用 Products 表中的产品。这些产品通过供应商ID联结
	到Vendors表中相应的供应商，供应商ID存储在每个产品的记录中。
	比如之前我们看到的一长串的子查询：
	SELECT * FROM Customers WHERE cust_id IN (SELECT cust_id FROM Orders WHERE order_num IN (SELECT order_num FROM OrderItems WHERE prod_id='RGAN01'));
	学习到了联结之后，于是可以改写为：
	SELECT cust_name,cust_contact FROM Customers,Orders,OrderItems WHERE Customers.cust_id=Orders.cust_id AND OrderItems.order_num=Orders.order_num
	AND prod_id='RGAN01';
		+---------------+--------------------+
		| cust_name     | cust_contact       |
		+---------------+--------------------+
		| Fun4All       | Denise L. Stephens |
		| The Toy Store | Kim Howard         |
		+---------------+--------------------+

	下面的内容对应第十三课，也就是创建高级联结
6.使用表别名
	好处：1)缩短SQL语句；
		  2)允许在一条SELECT 语句中多次使用相同的表。
	eg.	SELECT cust_name,cust_contact FROM Customers AS C,Orders AS O,OrderItems AS OI WHERE C.cust_id=O.cust_id 
		AND OI.order_num=O.order_num AND prod_id='RGAN01';
		+---------------+--------------------+
		| cust_name     | cust_contact       |
		+---------------+--------------------+
		| Fun4All       | Denise L. Stephens |
		| The Toy Store | Kim Howard         |
		+---------------+--------------------+
7.使用不同类型的联结
	到现在为止，我们使用的只是内联结或者等值联结的简单联结。现在就看一下其他的联结：自联结（self-join）、自然联结(natural join) 和外联结（outer join）
	1)自联结(self-join)
		通过前面可以看到，使用表别名的一个主要原因是能在一条SELECT语句中不止一次的引用相同的表。
		假设要给与Jim Jones同一公司的所有顾客发送一封邮件。那么应该怎么进行操作呢？
			首先需要找出Jim Jones工作的公司；然后再找出在该公司工作的顾客。
		下面是解决该问题的一种方式：使用子查询来解决问题
		SELECT cust_id,cust_name,cust_contact FROM Customers WHERE cust_name=(SELECT cust_name FROM Customers WHERE cust_contact='Jim Jones');
		+------------+-----------+--------------------+
		| cust_id    | cust_name | cust_contact       |
		+------------+-----------+--------------------+
		| 1000000003 | Fun4All   | Jim Jones          |
		| 1000000004 | Fun4All   | Denise L. Stephens |
		+------------+-----------+--------------------+
		
		那么是否是可以使用联结来进行查询呢？接下来看看使用联结进行查询的语句：
		SELECT c1.cust_id,c1.cust_name,c1.cust_contact FROM Customers AS c1,Customers AS c2 WHERE c1.cust_name=c2.cust_name AND c2.cust_contact='Jim Jones';
		+------------+-----------+--------------------+
		| cust_id    | cust_name | cust_contact       |
		+------------+-----------+--------------------+
		| 1000000003 | Fun4All   | Jim Jones          |
		| 1000000004 | Fun4All   | Denise L. Stephens |
		+------------+-----------+--------------------+
		可以看到，两个查询起到的是相同的结果，则它们的功能一致。
		那么为什么同样的都是使用Customers表，为什么要给这两个Customers 表起不一样的别名呢？
			如果不这样，DBMS将会返回错误，因为cust_id,cust_contact,cust_name各有两个，DBMS不知道具体去引用哪一个
		
		在一般的情况下，自联结的查询的速度一般比子查询速度快，所以推荐使用自联结而不是子查询。
		
	2)自然联结(natural join)
		无论何时进行联结，应该至少有一列不止出现在一个表中（被联结的列）。内联结返回所有的数据，相同的列甚至出现多次。自然联结排除多次出现，使每一列只返回一次。
		那么怎么样完成这项工作呢？主要是自己完成。
		自然联结要求你只能选择那些唯一的列，一般通过对一个表使用通配符（SELECT *），而对其他表的列使用明确的子集。
		eg.	SELECT C.*,O.order_num,O.order_date,OI.prod_id,OI.quantity,OI.item_price FROM Customers AS C,Orders AS O,OrderItems AS OI
		WHERE C.cust_id=O.cust_id AND OI.order_num=O.order_num AND prod_id='RGAN01';
			
	3)外联结(outer join)
		许多联结将一个表中的行与另一个表中的行相关联，但有时候需要包含没有关联行的那些行。例如需要完成以下工作：
		1)对每个顾客下的订单进行计数，包括那些至今尚未下订单的顾客；
		2)列出所有的订单以及订购数量，包括没有人订购的产品；
		3)计算平均销售规模，包括那些至今尚未下订单的顾客。
	在上述的例子中，联结包含了那些在关联表中没有关联的行。这种联结称为外联结。
	外联结指LEFT JOIN(RIGHT JOIN 与之类似)
	SELECT Customers.cust_id,Orders.order_num FROM Customers LEFT JOIN Orders ON Customers.cust_id=Orders.cust_id;
		+------------+-----------+
		| cust_id    | order_num |
		+------------+-----------+
		| 1000000001 |     20005 |
		| 1000000001 |     20009 |
		| 1000000002 |      NULL |
		| 1000000003 |     20006 |
		| 1000000004 |     20007 |
		| 1000000005 |     20008 |
		+------------+-----------+
	外联结之INNER JOIN  ---->只检索出等值的行
	SELECT Customers.cust_id,Orders.order_num FROM Customers INNER JOIN Orders ON Customers.cust_id=Orders.cust_id;
		+------------+-----------+
		| cust_id    | order_num |
		+------------+-----------+
		| 1000000001 |     20005 |
		| 1000000001 |     20009 |
		| 1000000003 |     20006 |
		| 1000000004 |     20007 |
		| 1000000005 |     20008 |
		+------------+-----------+
	
	LEFT JOIN 、RIGHT JOIN、INNER JOIN的区别
	left join:左连接，返回包括左表中的所有记录和右表中联结字段相等的记录
	select * from A left join B on A .aid=B .aid (where 条件)
	right join:右连接，返回包括右表中的所有记录和左表中联结字段相等的记录
	举例和左连接一样
	inner join:等值连接，只返回两个表中连接字段相等的行。
	举例如下： 
	--------------------------------------------
	表A记录如下：
	aID　　　　　aNum
	1　　　　　a20050111
	2　　　　　a20050112
	3　　　　　a20050113
	4　　　　　a20050114
	5　　　　　a20050115
	表B记录如下:
	bID　　　　　bName
	1　　　　　2006032401
	2　　　　　2006032402
	3　　　　　2006032403
	4　　　　　2006032404
	8　　　　　2006032408
	--------------------------------------------
	1.left join
	sql语句如下: 
	select * from A
	left join B 
	on A.aID = B.bID
	结果如下:
	aID　　　　　aNum　　　　　bID　　　　　bName
	1　　　　　a20050111　　　　1　　　　　2006032401
	2　　　　　a20050112　　　　2　　　　　2006032402
	3　　　　　a20050113　　　　3　　　　　2006032403
	4　　　　　a20050114　　　　4　　　　　2006032404
	5　　　　　a20050115　　　　NULL　　　　　NULL
	（所影响的行数为 5 行）
	结果说明:
	left join是以A表的记录为基础的,A可以看成左表,B可以看成右表,left join是以左表为准的.
	换句话说,左表(A)的记录将会全部表示出来,而右表(B)只会显示符合搜索条件的记录(例子中为: A.aID = B.bID).
	B表记录不足的地方均为NULL.
	--------------------------------------------
	2.right join
	sql语句如下: 
	select * from A
	right join B 
	on A.aID = B.bID
	结果如下:
	aID　　　　　aNum　　　　　bID　　　　　bName
	1　　　　　a20050111　　　　1　　　　　2006032401
	2　　　　　a20050112　　　　2　　　　　2006032402
	3　　　　　a20050113　　　　3　　　　　2006032403
	4　　　　　a20050114　　　　4　　　　　2006032404
	NULL　　　　　NULL　　　　　8　　　　　2006032408
	（所影响的行数为 5 行）
	结果说明:
	仔细观察一下,就会发现,和left join的结果刚好相反,这次是以右表(B)为基础的,A表不足的地方用NULL填充.
	--------------------------------------------
	3.inner join
	sql语句如下: 
	select * from A
	innerjoin B 
	on A.aID = B.bID
	结果如下:
	aID　　　　　aNum　　　　　bID　　　　　bName
	1　　　　　a20050111　　　　1　　　　　2006032401
	2　　　　　a20050112　　　　2　　　　　2006032402
	3　　　　　a20050113　　　　3　　　　　2006032403
	4　　　　　a20050114　　　　4　　　　　2006032404
	结果说明:
	很明显,这里只显示出了 A.aID = B.bID的记录.这说明inner join并不以谁为基础,它只显示符合条件的记录.
	--------------------------------------------
	注: 
	LEFT JOIN操作用于在任何的 FROM 子句中，组合来源表的记录。使用 LEFT JOIN 运算来创建一个左边外部联接。左边外部联接将包含了从第一个（左边）
	开始的两个表中的全部记录，即使在第二个（右边）表中并没有相符值的记录。
	语法：FROM table1 LEFT JOIN table2 ON table1.field1 compopr table2.field2
	说明：table1, table2参数用于指定要将记录组合的表的名称。
	field1, field2参数指定被联接的字段的名称。且这些字段必须有相同的数据类型及包含相同类型的数据，但它们不需要有相同的名称。
	compopr参数指定关系比较运算符："="， "<"， ">"， "<="， ">=" 或 "<>"。
	如果在INNER JOIN操作中要联接包含Memo 数据类型或 OLE Object 数据类型数据的字段，将会发生错误. 

8.使用带聚集函数的联结
	例如：要检索所有的顾客即每个顾客所下的订单数，应该怎么完成这项工作呢？    -----> 可以使用COUNT来完成这项工作
	SELECT Customers.cust_id,COUNT(Orders.order_num) AS num_ord FROM Customers INNER JOIN Orders ON Customers.cust_id=Orders.cust_id
	GROUP BY Customers.cust_id;
		+------------+---------+
		| cust_id    | num_ord |
		+------------+---------+
		| 1000000001 |       2 |
		| 1000000003 |       1 |
		| 1000000004 |       1 |
		| 1000000005 |       1 |
		+------------+---------+
9.小结
	1)注意所使用的联结类型
	2)应该总是 提供联结条件，否则会得出笛卡尔积
	3)在一个联结中可以包含多个表，甚至可以对每个联结采用不同的联结类型。
	
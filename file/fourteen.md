	·更新和删除数据(UPDATE 和 DELETE)
	更新和删除表
1.更新数据
	当需要更新 （修改）表中的数据的时候，可以使用UPDATE 子句，有两种使用UPDATE 的方式：
		1)更新表中特定的行
		如前面可知，1000000005客户是没有email，假如他注册了一个email，那我们就需要去更新这个值
		UPDATE Customers SET cust_email='kim@thetoystore.com' WHERE cust_id='1000000005';
		这样该客户的email值就更新了。
		
		注意：千万要仔细后面的WHERE子句，如果WHERE子句忘记写了，那么所有客户的email都会被更改，这是我们所不想看到的。
		
		假设需要更新多个列：
		eg.	UPDATE Customers SET cust_email='sam@toyland.com',cust_contact='Sam Roberts' WHERE cust_id='1000000006'
		
		但是，假设1000000005客户一段时间之后，该email就不再使用了，那我们必须将其置为NULL
		UPDATE Customers SET cust_email=NULL WHERE cust_id='1000000005';
		
		注意：不要写成''这个形式，这样子不是NULL，而是表示一个值。
		
		2)更新表中所有的行
			假设我们需要将从新统计所有用户的email，那么先要将表中所有的用户的email置为NULL，然后再每一个人的更新，全部置为NULL操作就是不需要带过滤条件。
			UPDATE Customers SET cust_email=NULL;
			这样操作即完成了将所有用户的email置为NULL。
		
2.删除数据
	从一个表中删除数据，那么我们需要使用DELETE语句，同样的，有两种使用DELETE子句的方式
		1)删除特定的行
		加入我们需要删除1000000006号用户，那么执行下面的操作即可完成。
		DELETE FROM Customers WHERE cust_id='1000000006';
		
		2)删除所有的行
		再不加上所有的过滤条件的时候，那么删除所有的行操作为：
		DELETE FROM Customers;

	DELETE 不需要列名或通配符。DELETE 删除整行而不是删除列。要删除特定的列，则是需要UPDATE 语句。
	
3.更新表
	语法：ALTER TABLE 表名 ADD|CHANGE|DROP 列名 类型;
	eg.	ALTER TABLE Vendors ADD vend_phone varchar(20);
	语句说明；这即是为 Vendors 表增加新一列 vend_phone.
	
	其他的操作同理可得。
	
4.删除表
	语法:DROP TABLE 表名;
	eg.	DROP TABLE CustCopy;
	
5.重命名表
	rename table 原表名 to 新表名;
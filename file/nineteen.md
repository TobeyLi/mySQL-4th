### 常见SQL特性

#### 约束（constraint）

定义：管理如何插入或处理数据库数据的规则。

DBMS通过在数据库表中施加约束来实施引用的完整性。大多数的约束是在表定义中定义的。用`CREATE TABLE` 或者`ALTER TABLE` 语句

1.主键约束

​	主键是一种特殊的约束，用来保证一列（或一组列）中的值是唯一的，而且永不改动。表中任意列只要满足以下条件，都可以适用于主键：

​	1）任意两行的主键值都不相同。

​	2）每行都有一个主键值（即列中不允许存在NULL值）。

​	3）包含主键值的列从不修改或者更新

​	4）主键值不能重用。

示例代码如下：

`CREATE TABLE Vendors
(
  vend_id      char(10) NOT NULL PRIMARY KEY ,
  vend_name    char(50) NOT NULL ,
  vend_address char(50) NULL ,
  vend_city    char(50) NULL ,
  vend_state   char(5)  NULL ,
  vend_zip     char(10) NULL ,
  vend_country char(50) NULL 
);`

在此例子中，给表的`vend_id`列定义添加关键字`PRIMARY KEY`使其成为主键

或者你在创建的时候没有指定主键，最后也可以使用如下语句来使其成为主键：

`ALTER TABLE Vendors ADD CONTRAINT PRIMARY KEY (vend_id);`

2.外键

定义：外键是表中的一列，其值必须列在另一表的主键中。外键是保证引用完整性的极其重要的部分。若有两个表A、B，id是A的主键，而B中也有id字段，则id就是表B的外键，外键约束主要用来维护两个表之间数据的一致性。

外键的定义（同样存在两种方式）：

`CREATE TABLE Orders
(
  order_num  int      NOT NULL  PRIMARY KEY，
  order_date datetime NOT NULL ,
  cust_id    char(10) NOT NULL  REFERENCES Customers（cust_id）
);`

另外一种的定义方式是：

`ALTER TABLE ORDERS ADD CONSTRAINT FOREIGN KEY (cust_id) REFERENCES Customers (cust_id)`

3.唯一约束

唯一约束是用来保证一列（或者一组列）中的数据时唯一的。它们类似于主键，但是有以下重要的区别：

a.表可以包含多个唯一约束，但是每个表只允许一个主键；

b.唯一约束列可以包含NULL；

c.唯一约束列可以修改或者更新；

d.唯一约束列的值可以重复使用；

e.与主键不一样，唯一约束不能用来定义外键。

唯一约束的语法和主键的定义以及外键的定义的方法相同，是将其对应的关键字变为UNIQUE。

4.检查约束

检查约束用来保证一列（或者是一组列）中的数据满足一组指定的条件。检查约束的常见用途有以下几点：

a.检查最大值或者最小值；

b.指定范围：如，保证发货日期大于等于今天的日期，但是不超过今天起一年后的日期

c.只允许特定的值。如，在性别字段只允许存在M或者F。

例如，对OrderItems表施加检查约束，它保证所有物品的数量大于0。

`CREATE TABLE OrderItems
(
  order_num  int          NOT NULL ,
  order_item int          NOT NULL ,
  prod_id    char(10)     NOT NULL ,
  quantity   int          NOT NULL  CHECK (quantity>0),
  item_price decimal(8,2) NOT NULL 
);`

若检查名为gender的列只包含M或者F，可以编写如下语句：

`ADD CONSTRAINT CHECK (gender LIKE '[MF]');`

#### 索引

索引的作用：索引是用来排序数据以加快搜索和排序操作的速度。使用索引，就不用每次都需要从表头开始查找。

可以在一个或者多个列上定义索引，使DBMS保存其内容的一个排过序的列表。

例如创建索引如下：

`CREATE INDEX prod_name_ind ON Products (prod_name);`

注意：所以必须唯一命名（此例中的名字为prod_name_ind）

#### 触发器

#####什么是触发器

触发器是与表有关的数据库对象，在满足定义条件时触发，并执行触发器中定义的语句集合。触发器的这种特性可以协助应用在数据库端确保数据的完整性。

举个例子，比如你现在有两个表【用户表】和【日志表】，当一个用户被创建的时候，就需要在日志表中插入创建的log日志，如果在不使用触发器的情况下，你需要编写程序语言逻辑才能实现，但是如果你定义了一个触发器，触发器的作用就是当你在用户表中插入一条数据的之后帮你在日志表中插入一条日志信息。当然触发器并不是只能进行插入操作，还能执行修改，删除。

## #####创建触发器

创建触发器的语法如下：

```
CREATE TRIGGER trigger_name trigger_time trigger_event ON tb_name FOR EACH ROW trigger_stmt
trigger_name：触发器的名称
tirgger_time：触发时机，为BEFORE或者AFTER
trigger_event：触发事件，为INSERT、DELETE或者UPDATE
tb_name：表示建立触发器的表明，就是在哪张表上建立触发器
trigger_stmt：触发器的程序体，可以是一条SQL语句或者是用BEGIN和END包含的多条语句
所以可以说MySQL创建以下六种触发器：
BEFORE INSERT,BEFORE DELETE,BEFORE UPDATE
AFTER INSERT,AFTER DELETE,AFTER UPDATE
```

其中，触发器名参数指要创建的触发器的名字

BEFORE和AFTER参数指定了触发执行的时间，在事件之前或是之后

FOR EACH ROW表示任何一条记录上的操作满足触发事件都会触发该触发器

##### 创建有多个执行语句的触发器

```
CREATE TRIGGER 触发器名 BEFORE|AFTER 触发事件
ON 表名 FOR EACH ROW
BEGIN
    执行语句列表
END
```

其中，BEGIN与END之间的执行语句列表参数表示需要执行的多个语句，不同语句用分号隔开

**tips：**一般情况下，mysql默认是以 ; 作为结束执行语句，与触发器中需要的分行起冲突

　　   为解决此问题可用DELIMITER，如：DELIMITER ||，可以将结束符号变成||

　　   当触发器创建完成后，可以用DELIMITER ;来将结束符号变成;

上面的语句中，开头将结束符号定义为||，中间定义一个触发器，一旦有满足条件的删除操作

就会执行BEGIN和END中的语句，接着使用||结束

最后使用DELIMITER ; 将结束符号还原

tigger_event：

![img](https://images2017.cnblogs.com/blog/1147480/201709/1147480-20170922213401446-423405198.png)

load data语句是将文件的内容插入到表中，相当于是insert语句，而replace语句在一般的情况下和insert差不多，但是如果表中存在primary 或者unique索引的时候，如果插入的数据和原来的primary key或者unique相同的时候，会删除原来的数据，然后增加一条新的数据，所以有的时候执行一条replace语句相当于执行了一条delete和insert语句。

触发器可以是一条SQL语句，也可以是多条SQL代码块，那如何创建呢？

```
DELIMITER $  #将语句的分隔符改为$
BEGIN
sql1;
sql2;
...
sqln
END $
DELIMITER ;  #将语句的分隔符改回原来的分号";"
```

在BEGIN...END语句中也可以定义变量，但是只能在BEGIN...END内部使用：

```
DECLARE var_name var_type [DEFAULT value] #定义变量，可指定默认值
SET var_name = value  #给变量赋值
```

NEW和OLD的使用:

 ![img](https://images2017.cnblogs.com/blog/1147480/201709/1147480-20170922213509837-496822531.png)

 根据以上的表格，可以使用一下格式来使用相应的数据：

```
NEW.columnname：新增行的某列数据
OLD.columnname：删除行的某列数据
```

说了这么多现在我们来创建一个触发器吧！

现在有表如下：
用户users表

```
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `add_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`(250)) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1000001 DEFAULT CHARSET=latin1;
```

日志logs表：

```
CREATE TABLE `logs` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `log` varchar(255) DEFAULT NULL COMMENT '日志说明',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日志表';
```

需求是：当在users中插入一条数据，就会在logs中生成一条日志信息。

创建触发器：

```
DELIMITER $
CREATE TRIGGER user_log AFTER INSERT ON users FOR EACH ROW
BEGIN
DECLARE s1 VARCHAR(40)character set utf8;
DECLARE s2 VARCHAR(20) character set utf8;#后面发现中文字符编码出现乱码，这里设置字符集
SET s2 = " is created";
SET s1 = CONCAT(NEW.name,s2);     #函数CONCAT可以将字符串连接
INSERT INTO logs(log) values(s1);
END $
DELIMITER ;
```

#### 查看触发器

##### SHOW TRIGGERS语句查看触发器信息

回到上面,我们创建好了触发器,继续在users中插入数据并查看数据：

```
insert into users(name,add_time) values('周伯通',now());
```

然后可以去查看logs表，通过上面的例子，可以看到只需要在users中插入用户的信息，日志会自动记录到logs表中，这也许就是触发器给我带来的便捷吧！

## 限制和注意事项

触发器会有以下两种限制：

1.触发程序不能调用将数据返回客户端的存储程序，也不能使用采用CALL语句的动态SQL语句，但是允许存储程序通过参数将数据返回触发程序，也就是存储过程或者函数通过OUT或者INOUT类型的参数将数据返回触发器是可以的，但是不能调用直接返回数据的过程。

2.不能再触发器中使用以显示或隐式方式开始或结束事务的语句，如START TRANS-ACTION,COMMIT或ROLLBACK。

注意事项：MySQL的触发器是按照BEFORE触发器、行操作、AFTER触发器的顺序执行的，其中任何一步发生错误都不会继续执行剩下的操作，如果对事务表进行的操作，如果出现错误，那么将会被回滚，如果是对非事务表进行操作，那么就无法回滚了，数据可能会出错。

 

## 总结

触发器是基于行触发的，所以删除、新增或者修改操作可能都会激活触发器，所以不要编写过于复杂的触发器，也不要增加过得的触发器，这样会对数据的插入、修改或者删除带来比较严重的影响，同时也会带来可移植性差的后果，所以在设计触发器的时候一定要有所考虑。

触发器是一种特殊的存储过程，它在插入，删除或修改特定表中的数据时触发执行，它比数据库本身标准的功能有更精细和更复杂的数据控制能力。

数据库触发器有以下的作用：

1.安全性。可以基于数据库的值使用户具有操作数据库的某种权利。

   可以基于时间限制用户的操作，例如不允许下班后和节假日修改数据库数据。

  可以基于数据库中的数据限制用户的操作，例如不允许股票的价格的升幅一次超过10%。

2.审计。可以跟踪用户对数据库的操作。   

  审计用户操作数据库的语句。

  把用户对数据库的更新写入审计表。

3.实现复杂的数据完整性规则

   实现非标准的数据完整性检查和约束。触发器可产生比规则更为复杂的限制。与规则不同，触发器可以引用列或数据库对象。例如，触发器可回退任何企图吃进超过自己保证金的期货。

   提供可变的缺省值。

4.实现复杂的非标准的数据库相关完整性规则。触发器可以对数据库中相关的表进行连环更新。例如，在auths表author_code列上的删除触发器可导致相应删除在其它表中的与之匹配的行。

   在修改或删除时级联修改或删除其它表中的与之匹配的行。

  在修改或删除时把其它表中的与之匹配的行设成NULL值。

  在修改或删除时把其它表中的与之匹配的行级联设成缺省值。

  触发器能够拒绝或回退那些破坏相关完整性的变化，取消试图进行数据更新的事务。当插入一个与其主健不匹配的外部键时，这种触发器会起作用。例如，可以在books.author_code 列上生成一个插入触发器，如果新值与auths.author_code列中的某值不匹配时，插入被回退。

5.同步实时地复制表中的数据。

6.自动计算数据值，如果数据的值达到了一定的要求，则进行特定的处理。例如，如果公司的帐号上的资金低于5万元则立即给财务人员发送警告数据。

#### 数据库安全

一般来说，需要保护的操作有：

​	1.对数据库管理功能（常见、删除和更改已经存在的表等）的访问

​	2.对特定数据库或者表的访问

​	3.访问的类型（只读，以及对特定列的访问）

​	4.仅通过视图或存储过程对表进行访问

​	5.常见多层次的安全措施，从而允许多种基于登陆的访问和控制

​	6.限制管理用户账号的能力

安全性使用SQL的GRANT和REVOKE语句来管理。


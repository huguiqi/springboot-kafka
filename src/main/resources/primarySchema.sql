DROP TABLE if EXISTS car;

CREATE TABLE car(
id  INT(10) NOT NULL AUTO_INCREMENT COMMENT '自增的id主键',
make VARCHAR (255) not NULL ,
model VARCHAR (255) not NULL ,
YEAR INT(10)  not NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


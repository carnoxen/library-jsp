<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 해당 도서를 예약한다. --%>
<!doctype html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<c:catch>
			<sql:update sql="insert into 
								reserves(reserve_num, member_num) 
								values(?,?)">
				<sql:param value="${login_order_num}" />
				<sql:param value="${login_id}" />
			</sql:update>
		</c:catch>
		<c:catch>
			<sql:update sql="insert into 
								reserve_library_books(register_num, reserve_num, reserve_timestamp) 
								values(?,?, systimestamp)">
				<sql:param value="${param.register_num}" />
				<sql:param value="${login_order_num}" />
			</sql:update>
		</c:catch>
	</sql:transaction>
	<c:redirect url="/mine/reserve" />
</html>
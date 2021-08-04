<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 해당 도서를 상호대차한다. --%>
<!doctype html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<c:catch>
			<sql:update sql="insert into 
								loans(loan_num, member_num) 
								values(?,?)">
				<sql:param value="${login_order_num}" />
				<sql:param value="${login_id}" />
			</sql:update>
		</c:catch>
		<sql:update sql="insert into 
							loan_library_books(register_num, loan_num, library_num) 
							values(?,?,?)">
			<sql:param value="${param.register_num}" />
			<sql:param value="${login_order_num}" />
			<sql:param value="${param.library_num}" />
		</sql:update>
	</sql:transaction>
	<c:redirect url="/mine/loan" />
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 홈페이지에 로그인한다. 자신의 회원번호, 비밀번호가 있어야 한다. --%>
<!doctype html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:query dataSource="${snapshot}" var="result"
		sql="select 
				member_num, 
				member_name, 
				library_num, 
				to_number(to_char(sysdate, 'YYYYMMDD')||LPAD(member_num, 4, 0)) order_num 
			from 
				members 
			where 
				member_num like ? and 
				password like ?">
		<sql:param value="${param.id}" />
		<sql:param value="${param.passwd}" />
	</sql:query>
	<c:if test="${result.rowCount eq 0}">
		<c:redirect url="/login">
			<c:param name="error">member not found</c:param>
		</c:redirect>
	</c:if>
	<c:forEach var="row" items="${result.rows}">
		<c:set var="login_id" scope="session" value="${row.member_num}" />
		<c:set var="login_name" scope="session" value="${row.member_name}" />
		<c:set var="login_order_num" scope="session" value="${row.order_num}" />
	</c:forEach>
	<c:redirect url="/" />
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 해당 도서의 예약을 해제한다 --%>
<!doctype html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<sql:update sql="delete from 
							reserve_library_books 
						where 
							register_num = ? and 
							reserve_num = ?">
			<sql:param value="${param.register_num}" />
			<sql:param value="${param.reserve_num}" />
		</sql:update>
		<c:catch>
			<sql:update sql="delete from 
								reserves 
							where 
								reserve_num = ?">
				<sql:param value="${param.reserve_num}" />
			</sql:update>
		</c:catch>
	</sql:transaction>
	<c:redirect url="/mine/reserve" />
</html>
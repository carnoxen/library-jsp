<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 해당 도서의 대출 기간을 10일 연장한다. --%>
<!doctype html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<sql:update sql="update 
							borrow_library_books 
						set 
							extend_count = extend_count - 1 
						where 
							borrow_num = ? and 
							register_num = ?">
			<sql:param value="${param.borrow_num}" />
			<sql:param value="${param.register_num}" />
		</sql:update>
	</sql:transaction>
	<c:redirect url="/mine/borrow" />
</html>
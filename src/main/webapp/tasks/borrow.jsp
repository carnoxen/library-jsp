<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 해당 도서를 대출한다. --%>
<!doctype html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<c:catch>
			<sql:update sql="insert into 
								borrows(borrow_num, member_num) 
								values(?, ?)">
				<sql:param value="${login_order_num}" />
				<sql:param value="${login_id}" />
			</sql:update>
		</c:catch>
		<c:catch var="borrowException">
			<sql:update sql="insert into 
								borrow_library_books(register_num, borrow_num, borrow_date) 
								values(?,?, trunc(sysdate))">
				<sql:param value="${param.register_num}" />
				<sql:param value="${login_order_num}" />
			</sql:update>
		</c:catch>
		<c:if test="${not empty borrowException}">
			<sql:update sql="update 
								borrow_library_books 
							set 
								extend_count = 2, 
								return_date = null 
							where 
								register_num = ? and 
								borrow_num = ?">
				<sql:param value="${param.register_num}" />
				<sql:param value="${login_order_num}" />
			</sql:update>
		</c:if>
		<c:if test="${not empty param.loan_num}">
			<sql:update sql="update 
								borrow_library_books 
							set 
								is_loan = 1 
							where 
								register_num = ? and 
								borrow_num = ?">
				<sql:param value="${param.register_num}" />
				<sql:param value="${login_order_num}" />
			</sql:update>
			<sql:update sql="delete from 
								loan_library_books 
							where 
								register_num = ? and 
								loan_num = ?">
				<sql:param value="${param.register_num}" />
				<sql:param value="${param.loan_num}" />
			</sql:update>
			<c:catch>
				<sql:update sql="delete from 
									loans 
								where 
									loan_num = ?">
					<sql:param value="${param.loan_num}" />
				</sql:update>
			</c:catch>
		</c:if>
		<c:if test="${not empty param.reserve_num}">
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
		</c:if>
	</sql:transaction>
	<c:redirect url="/mine/borrow" />
</html>
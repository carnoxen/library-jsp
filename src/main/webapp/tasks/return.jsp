<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 해당 도서를 반납한다. 연체가 되었으면 상황에 따라 대출/상호대차 정지 기한을 둔다. --%>
<!doctype html>
<html>
	<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.driver.OracleDriver"
		url = "jdbc:oracle:thin:@localhost:1521:xe"
		user = "hr"  password = "1234"/>
	<sql:transaction dataSource="${snapshot}">
		<sql:query var="limit"
			sql="select 
					f_return_limit(borrow_date, extend_count) return_limit, 
					is_loan 
				from 
					borrow_library_books 
				where 
					borrow_num = ? and 
					register_num = ?">
			<sql:param value="${param.borrow_num}" />
			<sql:param value="${param.register_num}" />
		</sql:query>
		<c:forEach var="row" items="${limit.rows}">
			<sql:update sql="update 
								members 
							set 
								borrow_restrict_limit = trunc(sysdate) + to_number(trunc(sysdate) - ?) 
							where 
								? < trunc(sysdate) and 
								member_num = ?">
				<sql:dateParam type="date" value="${row.return_limit}" />
				<sql:dateParam type="date" value="${row.return_limit}" />
				<sql:param value="${login_id}" />
			</sql:update>
			<c:if test="${row.is_loan eq 1}">
				<sql:update sql="update 
									members 
								set 
									loan_restrict_limit = trunc(sysdate) + 10 
								where 
									? < trunc(sysdate) and 
									member_num = ?">
					<sql:param value="${row.return_limit}" />
					<sql:param value="${login_id}" />
				</sql:update>
			</c:if>
		</c:forEach>
		<sql:update sql="update 
							borrow_library_books 
						set 
							return_date = trunc(sysdate) 
						where 
							borrow_num = ? and 
							register_num = ?">
			<sql:param value="${param.borrow_num}" />
			<sql:param value="${param.register_num}" />
		</sql:update>
		<sql:query var="reserves"
			sql="select 
					reserve_num 
				from 
					(select 
						* 
					from 
						reserve_library_books 
					where 
						register_num = ? and 
						notify_date is null 
					order by 
						reserve_timestamp) 
				where 
					rownum = 1">
			<sql:param value="${param.register_num}" />
		</sql:query>
		<c:forEach var="row" items="${reserves.rows}">
			<sql:update sql="update 
								reserve_library_books  
							set 
								notify_date = trunc(sysdate) 
							where 
								register_num = ? and 
								reserve_num = ?">
				<sql:param value="${param.register_num}" />
				<sql:param value="${row.reserve_num}" />
			</sql:update>
		</c:forEach>
	</sql:transaction>
	<c:redirect url="/mine/borrow" />
</html>
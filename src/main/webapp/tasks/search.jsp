<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="library.SearchEngine" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 입력받은 쿼리를 파싱해 /search 페이지로 전달 --%>
<html>
	<c:redirect url="/search">
		<c:param name="query"><%= SearchEngine.parseBookSearchInput(request.getParameter("search_text")) %></c:param>
	</c:redirect>
</html>
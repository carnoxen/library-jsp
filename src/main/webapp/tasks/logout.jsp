<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 홈페이지에서 로그아웃한다. --%>
<% session.invalidate(); %>
<c:redirect url="/" />
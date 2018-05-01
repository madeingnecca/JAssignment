<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<%
            int currentPage;
            
            try {
                Integer level = (Integer) request.getAttribute(Constants.LEVEL_REQUEST_KEY);
                currentPage = level.intValue();
            } catch (Exception e) {
                currentPage = Constants.LEVEL_HOME;
            }

            switch (currentPage) {

                case Constants.LEVEL_HOME: {
                    %>
                    <%@ include file="../includes/body-admin-home.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_COURSES: {
                    %>
                    <%@ include file="../includes/body-admin-level-courses.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_EXERCISES: {
                    %>
                    <%@ include file="../includes/body-admin-level-exercises.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_SUB_EX: {
                    %>
                    <%@ include file="../includes/body-admin-level-subex.jsp" %>
                    <%
                    break;
                }                
                case Constants.LEVEL_SUBMISSIONS_1: {
                    %>
                    <%@ include file="../includes/body-admin-level-submissions1.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_SUBMISSIONS_2: {
                    %>
                    <%@ include file="../includes/body-admin-level-submissions2.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_TEXT_SUBMITTED: {
                    %>
                    <%@ include file="../includes/body-admin-level-submitted.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_ACTIVITY: {

                    Integer sublevel = (Integer) request.getAttribute(Constants.SUB_LEVEL_REQUEST_KEY);

                    switch (sublevel) {
			case Constants.LEVEL_LANGUAGES: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-languages.jsp" %>
                        <%
                             break;
			}
			case Constants.LEVEL_NEW_LANGUAGE: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-new-language.jsp" %>
                        <%
                             break;
			}
			case Constants.LEVEL_EDIT_LANGUAGES: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-edit-languages.jsp" %>
                        <%
                             break;
			}
			case Constants.LEVEL_REPORT_SINGLE: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-report.jsp" %>
                        <%
                             break;
			}
			case Constants.LEVEL_SEARCH_STUD: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-searchstud.jsp" %>
                        <%
                             break;
			}
                        case Constants.LEVEL_ADMINS: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-admins.jsp" %>
                        <%
                                break;
                            }
			case Constants.LEVEL_EDIT_ADMIN: {
			    %>
			    <%@ include file="../includes/body-admin-level-activity-editadmins.jsp" %>
			    <%
			    break;
			}
                            case Constants.LEVEL_NEW_ADMIN: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-new-admin.jsp" %>
                        <%
                            break;
                        }
                            case Constants.LEVEL_NEW_COURSE: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-new-course.jsp" %>
                        <%
                                break;
                            }
                            case Constants.LEVEL_COURSES: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-courses.jsp" %>
                        <%
                                break;
                            }
                            case Constants.LEVEL_EDIT_COURSES: {
                        %>
                        <%@ include file="../includes/body-admin-level-activity-edit-courses.jsp" %>               
                                <%
                                break;
                            }
                            
                        }
                        break;
                }
            }
%>    

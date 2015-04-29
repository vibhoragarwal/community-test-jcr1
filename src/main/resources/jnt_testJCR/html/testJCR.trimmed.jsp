<%@ page contentType="text/html;charset=UTF-8" language="java"
  %><?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="javax.jcr.nodetype.PropertyDefinition"%>
<%@page import="org.jahia.services.usermanager.jcr.JCRUserManagerProvider"%>
<%@page import="javax.jcr.version.Version" %>
<%@page import="org.apache.commons.lang.StringUtils" %>
<%@page import="javax.jcr.version.VersionIterator" %>
<%@page import="java.util.*" %>
<%@ page import="org.jahia.api.Constants" %>
<%@ page import="org.jahia.services.content.*" %>
<%@ page import="org.jahia.services.content.nodetypes.NodeTypeRegistry" %>
<%@ page import="javax.jcr.nodetype.NodeType" %>
<%@ page import="javax.jcr.nodetype.NodeTypeIterator" %>
<%@ page import="javax.jcr.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="functions" uri="http://www.jahia.org/tags/functions"%>
<%@taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr"%>
<%@taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<link rel="stylesheet" href="/modules/jcrtest/css/font-awesome.css" media="screen" type="text/css"/>
<html xmlns="http://www.w3.org/1999/xhtml">
  <utility:useConstants var="jcrPropertyTypes" className="org.jahia.services.content.nodetypes.ExtendedPropertyType" scope="application"/>
  <c:set var="showProperties" value="${functions:default(fn:escapeXml(param.showProperties), 'false')}"/>
  <c:set var="showReferences" value="${functions:default(fn:escapeXml(param.showReferences), 'false')}"/>
  <c:set var="showNodes" value="${functions:default(fn:escapeXml(param.showNodes), 'true')}"/>
  <c:set var="showActions" value="${functions:default(fn:escapeXml(param.showActions), 'false')}"/>
  <c:set var="showVersions" value="${functions:default(param.showVersions, 'false')}"/>
  <c:set var="workspace" value="${functions:default(fn:escapeXml(param.workspace), 'default')}"/>
  <c:set var="nodeId" value="${not empty param.uuid ? fn:trim(fn:escapeXml(param.uuid)) : 'cafebabe-cafe-babe-cafe-babecafebabe'}"/>
  <c:set var="showJCRNodes" value="${not empty param.showJCRNodes ? fn:trim(fn:escapeXml(param.showJCRNodes)) : 'false'}"/>
  

  <%
   
     JCRSessionFactory.getInstance().setCurrentUser(JCRUserManagerProvider.getInstance().lookupRootUser());
     
     Session jcrSession = JCRSessionFactory.getInstance().getCurrentUserSession((String) pageContext.getAttribute("workspace"));
     
     
     Node node =  jcrSession.getNode(JCRContentUtils.escapeNodePath("/modules"));;
     pageContext.setAttribute("nodeId", node.getIdentifier());
     pageContext.setAttribute("node", node);
     pageContext.setAttribute("currentNode", node);
     
     Value versioningSupported = jcrSession.getRepository().getDescriptorValue(Repository.OPTION_SIMPLE_VERSIONING_SUPPORTED);
        if (versioningSupported != null && versioningSupported.getBoolean() && node.isNodeType(Constants.MIX_VERSIONABLE) && session instanceof JCRSessionWrapper) {
            VersionIterator versionIterator = jcrSession.getWorkspace().getVersionManager().getVersionHistory(node.getPath()).getAllLinearVersions();
            pageContext.setAttribute("versionIterator", versionIterator);

            Version v = jcrSession.getWorkspace().getVersionManager().getVersionHistory(node.getPath()).getRootVersion();

        }
     
 %>
    
    
    <p><strong>Child nodes</strong>
      <c:set var="nodes" value="${node.nodes}"/>
      <c:set var="childrenCount" value="${functions:length(nodes)}"/>
      <c:if test="${childrenCount > 0}">- ${childrenCount} nodes found</c:if>
    </p>
    <ul>
      
      <c:if test="${childrenCount == 0}"><li>No child nodes present</li></c:if>
      <c:if test="${childrenCount > 0}">
        <% System.out.println("---vvvvvvvvvvvvvvvvvvvvvvvv---"+pageContext.getAttribute("nodes"));%>
        <c:forEach items="${nodes}" var="child">
          <li>
            <h2><i class="fa fa-file-o"></i>  ${fn:escapeXml(child.name)}</b></h2>
          </li>
        </c:forEach> 
      </c:if>
    </ul>
    
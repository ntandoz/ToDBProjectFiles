<%@ include file="/WEB-INF/jsp/definition_elements/init.jsp" %>

<%@ page import="java.io.*"%>
<%@ page import= "java.net.*"%>
<%@ page import= "org.json.JSONArray"%>
<%@ page import= "com.sun.jersey.api.client.Client"%>
<%@ page import= "com.sun.jersey.api.client.ClientResponse"%>
<%@ page import= "com.sun.jersey.api.client.GenericType"%>
<%@ page import= "com.sun.jersey.api.client.WebResource"%>
<%@ page import= "com.sun.jersey.api.client.config.ClientConfig"%>
<%@ page import= "com.sun.jersey.api.client.config.DefaultClientConfig"%>
<%@ page import= "com.sun.jersey.api.client.filter.HTTPBasicAuthFilter"%>
<%@ page import= "com.sun.jersey.api.json.JSONConfiguration"%>
<%@ page import= "com.sun.jersey.client.urlconnection.HTTPSProperties"%>
<%@ page import= "com.todb.model.*"%>
<%@ page import= "java.security.cert.X509Certificate"%>
<%@ page import= "java.util.ArrayList"%>
<%@ page import= "java.util.Date"%>
<%@ page import= "java.util.List"%>
<%@ page import= "javax.net.ssl.HostnameVerifier"%>
<%@ page import= "javax.net.ssl.SSLContext"%>
<%@ page import= "javax.net.ssl.SSLSession"%>
<%@ page import= "javax.net.ssl.TrustManager"%>
<%@ page import= "javax.net.ssl.X509TrustManager"%>
<%@ page import= "javax.ws.rs.core.MultivaluedMap"%>
<%@ page import= "org.codehaus.jackson.jaxrs.JacksonJaxbJsonProvider"%>

<style>
/*
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
*/
/* 
    Created on : 21 Jul 2015, 9:57:44 PM
    Author     : wandam & ntandoz
*/

.hideDiv{
	    display: none;
	}
.showDiv{
	    display: block;
	}
</style>
 <script type="text/javascript">

            //Hidden tabs
            document.getElementById("detailsPage").className="hideDiv";
            document.getElementById("researchDetailsPage").className="hideDiv";
            document.getElementById("externalPublicationsPage").className="hideDiv";
            document.getElementById("externalAuthorsPage").className="hideDiv";
            document.getElementById("researchDetailsPage").className="showDiv";
            
             

            //Controll Variables
             var GenState=-1;
             var ResearchDetState=-1;
             var ExtPage=-1;

            function validateform()
            {  
		//var This is for the overall validation of the form
                 if( document.getElementById("detailsPage").className=="showDiv")
                    {
                          generalDetails();
                        
                     }
                  if( document.getElementById("researchDetailsPage").className=="showDiv")
                    {
                          validateResearchDetails();
                        
                     }
                  if( document.getElementById("externalPublicationsPage").className=="showDiv")
                    {
                          validateExternalPublications();  
                     } 
                  if(document.getElementById("externalAuthorsPage").className=="showDiv")  
                   {
                             
                             document.getElementById("externalAuthorsPage").className="hideDiv";
                             document.getElementById("researchDetailsPage").className="hideDiv";
                             document.getElementById("externalPublicationsPage").className="hideDiv";
                             document.getElementById("detailsPage").className="showDiv";
                    
                   }             
	    }

            //Function General Details
             
             function generalDetails()
             {

                      
                     
                        if(document.getElementById("title").value==null || document.getElementById("title").value=="")
			{  
				alert("Please type in the Title");  
                               document.getElementById("title").focus();
                               
			 	 return;
			 }
			if(document.getElementById("todbUsername").value==null || document.getElementById("todbUsername").value=="")
			{  
				alert("Was not able to access your name, please contact your administrator");
                                 document.getElementById("todbUsername").focus();  
			 	 return;
			 } 		 

			if (document.getElementById("todbStaffNumber").value==null || document.getElementById("todbStaffNumber").value=="")
			{  
				alert("Was not able to access the Staff Number");  
                                document.getElementById("todbStaffNumber").focus(); 
				 return;
			}
			if(document.getElementById("todbBusinessUnit").value==null || document.getElementById("todbBusinessUnit").value=="")
			{  
				alert("Business Unit can't be blank");  
                                document.getElementById("todbBusinessUnit").focus(); 
			 	 return;
			 }  
			if(document.getElementById("todbDepartment").value==null || document.getElementById("todbDepartment").value=="")
			{  
				alert("Could not access the Department, Please contact your Administrator");  
                                document.getElementById("todbDepartment").focus(); 
			 	 return;
			 }  
                         if(document.getElementById("todbRights").value==null || document.getElementById("todbRights").value=="")
			{  
				alert("Rights were not assigned");  
                                document.getElementById("todbRights").focus(); 
			 	 return;
			 }  
                         if(document.getElementById("todbCompetencyArea").value==null || document.getElementById("todbCompetencyArea").value=="")
			{  
				alert("Please Select Competency areas");  
                                document.getElementById("todbCompetencyArea").focus(); 
			 	 return;
			 }   
 
                         if(document.getElementById("todbDepartment").value!=null && document.getElementById("todbStaffNumber").value!=null 
			&& document.getElementById("todbBusinessUnit").value!=null && document.getElementById("todbDepartment").value!=null
                         && document.getElementById("todbCompetencyArea").value!=null )
	
			{    
                             localStorage.extGenState = "extGenSet";
                           

                             //general details validated
                             GenState=1;
                             if(GenState==1)
                             {
                             document.getElementById("detailsPage").className="hideDiv";
                             document.getElementById("externalAuthorsPage").className="hideDiv";
                             document.getElementById("externalPublicationsPage").className="hideDiv";
                             document.getElementById("researchDetailsPage").className="showDiv";
                            
                             }
                             
                             
			}
             }

            //This will update the Research Details
            function validateResearchDetails()
             {
                      
                       //check if details tab has been completed
                      


                     //Checking for the availability of values
                      if(document.getElementById("todbResearchFunding").value==null || document.getElementById("todbResearchFunding").value=="")
			{  
				alert("Please Enter a source of Research Funding");  
                               document.getElementById("todbResearchFunding").focus();
                               
                               
			 	 return;
			 }
                       else
                          { 
                             ResearchDetState=1;
                             if(ResearchDetState==1)
                             {
                              localStorage.researchState = "resSet";
                             document.getElementById("detailsPage").className="hideDiv";
                             document.getElementById("externalAuthorsPage").className="hideDiv";
                             document.getElementById("researchDetailsPage").className="hideDiv";
                             document.getElementById("externalPublicationsPage").className="showDiv";
                             }
                          }
             }

             //This will update the External Publications Tab
            function validateExternalPublications()
             {
                     //Checking for the availability of values
                      if(document.getElementById("todbPublicationType").value==null || document.getElementById("todbPublicationType").value=="")
			{  
				alert("Please select the Publication Type");  
                               document.getElementById("todbPublicationType").focus();
                               
			 	 return;
                             
			 }
                       if(document.getElementById("todbYear").value==null || document.getElementById("todbYear").value=="")
                         {
                              alert("Please select the year");  
                               document.getElementById("todbYear").focus();
                               
			 	 return;
                         }
                       if(document.getElementById("todbStatusOfDocument").value==null || document.getElementById("todbStatusOfDocument").value=="")
                         {
                              alert("Please select the Status of document");  
                               document.getElementById("todbStatusOfDocument").focus();
                               
			 	 return;
                         }

                         if(document.getElementById("todbReviewed").value==null || document.getElementById("todbReviewed").value=="")
                         {
                              alert("Please select the Request to Screen for IP");  
                               document.getElementById("todbReviewed").focus();
                               
			 	 return;
                         }
                        else
                       {
                           localStorage.extState = "extSet";
                           ss_buttonSelect('okBtn');
                       }
                    
             }

            function validateExternalAuthors()
             {
                     //Checking for the availability of values
                      if(document.getElementById("todbPublicationType").value==null || document.getElementById("todbPublicationType").value=="")
			{  
				alert("Please type in the Title");  
                               document.getElementById("todbPublicationType").focus();
                               
			 	 return;
			 }
             }

          

            function showDivFunction(id)
            {
		        document.getElementById("detailsPage").className="hideDiv";
		        document.getElementById("researchDetailsPage").className="hideDiv";
               	        document.getElementById("externalPublicationsPage").className="hideDiv";
                        document.getElementById("externalAuthorsPage").className="hideDiv";
             	        document.getElementById(id).className="showDiv";   
            }

            function loadProjectDesc(selectedId, descriptionId)
             {
                 document.getElementById(descriptionId).value = document.getElementById(selectedId).value;
                 var selval = document.getElementById(selectedId).options[document.getElementById(selectedId).selectedIndex].text;
                 document.getElementById(selectedId).options[document.getElementById(selectedId).selectedIndex].value = selval;
             }
 </script>



<!-- ***************************     Setting up variable for session states ****************************** -->
 <div id="detailsState"></div>
<div id="researchState"></div>
<div id="externalState"></div>
<div id="eaState"></div>

<%	
        //Business units used to populate fields

	com.sun.jersey.api.client.ClientResponse cresponse = null;
        String username = "user";
        String password = "password";
        String t = null;
	List<BusinessUnits> buList=null;
        List<CompAreas> compArea=null;
        List<PublicationType> pType=null;
        List<Ria> riaList=null;
        List<Flagship> flagShipList=null;
        List<ResearchData> researchList=null;
        List<SecurityClass> securityList=null;
        List<EntityIdent> empDetailsList=null;
        List<ProjectId> proIDs=null;
        List<ProjectId> proDes=null;

        //Override SSL verification for test purposes
        try {
            /*javax.net.ssl.TrustManager[] trustAllCerts = new javax.net.ssl.TrustManager[]{new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }

                public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                }

                public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                }
            }};*/

            com.sun.jersey.api.client.config.ClientConfig clientConfig = new com.sun.jersey.api.client.config.DefaultClientConfig();
            javax.net.ssl.SSLContext ctx = javax.net.ssl.SSLContext.getInstance("SSL");
            /*ctx.init(null, trustAllCerts, null);
            
            clientConfig.getProperties().put(HTTPSProperties.PROPERTY_HTTPS_PROPERTIES, new HTTPSProperties(new HostnameVerifier() {
                @Override
                public boolean verify(String s, javax.net.ssl.SSLSession sslSession) {
                    return true;
               }
            }, ctx));*/
            //End bypass SSL security
            
            clientConfig.getClasses().add(JacksonJaxbJsonProvider.class);            
            clientConfig.getFeatures().put(com.sun.jersey.api.json.JSONConfiguration.FEATURE_POJO_MAPPING, Boolean.TRUE);

            com.sun.jersey.api.client.Client todbclient = com.sun.jersey.api.client.Client.create(clientConfig);
            todbclient.addFilter(new com.sun.jersey.api.client.filter.HTTPBasicAuthFilter(username, password));

	   

            com.sun.jersey.api.client.WebResource todbresource = todbclient.resource("https://mule-test.csir.co.za/api/todb/");
           
           
           
            WebResource resource = todbclient.resource("https://mule-test.csir.co.za/api/todb/");
            
           

            //Publication Type
               cresponse = resource.path("publicationtype").accept("application/json").get(ClientResponse.class);
              pType = cresponse.getEntity(new GenericType<List<PublicationType>>() {});
      
            //Research Impact Areas     
              cresponse = resource.path("ria").accept("application/json").get(ClientResponse.class);
              riaList = cresponse.getEntity(new GenericType<List<Ria>>() {});
              
            //Flagships
              cresponse = resource.path("flagships").accept("application/json").get(ClientResponse.class);
              flagShipList = cresponse.getEntity(new GenericType<List<Flagship>>() {});

            //Security Classification
               cresponse = resource.path("securityclass").accept("application/json").get(ClientResponse.class);
               securityList = cresponse.getEntity(new GenericType<List<SecurityClass>>() {});
		System.out.println("Read Security Class: "+securityList.size());
            
            //Employee Details
               cresponse = resource.path("employees/"+request.getUserPrincipal().getName().toUpperCase()).accept("application/json").get(ClientResponse.class);
               empDetailsList = cresponse.getEntity(new GenericType<List<EntityIdent>>() {});

            //This code is for business Units
                cresponse = resource.path("businessunits/"+empDetailsList.get(0).getEntityOe1()).accept("application/json").get(ClientResponse.class);
                buList = cresponse.getEntity(new GenericType<List<BusinessUnits>>() {});
            
            //Competency Areas
                cresponse = resource.path("competencyareas/"+buList.get(0).getBuId()).accept("application/json").get(ClientResponse.class);
                compArea = cresponse.getEntity(new GenericType<List<CompAreas>>() {});
            
            //This code is for the projects
                cresponse = resource.path("projectids/").accept("application/json").get(ClientResponse.class);
                proIDs = cresponse.getEntity(new GenericType<List<ProjectId>>() {});
		System.out.println("Read Projects ID List: "+proIDs.size());
           
        } catch (Exception e) {
            t = e.getMessage();
        }
    
%>


<!-- ***************************     Doctype hidden Field ****************************** -->
<input type="hidden" name="todbDoctype" id="todbDoctype" value="EXT"/>

<!-- ***************************     Details Page Table Menu ****************************** -->
          <table>
                <tr>
                     	<td><input type="button" id="GeneralDetails" value="General Details"  
                                                  onclick="showDivFunction('detailsPage')"/></td>
			<td><input type="button" id="ResearchDetails" value="Research Details"  
                                                  onclick="showDivFunction('researchDetailsPage')"  /></td>
			<td><input type="button" id="ExternalDetails" value="External Publications"  
                                                  onclick="showDivFunction('externalPublicationsPage')"/></td>
			<td><input type="button" id="ExternalAuthorsDetails" value="External Authors"  
                                                  onclick="showDivFunction('externalAuthorsPage')"/></td>
                </tr>
          </table>

<!-- ***************************     Setting up a session ****************************** -->
			
                     

<!-- ***************************     Details Page    ****************************** -->
 <table id="detailsPage" class="showDiv">
                            
		<p>&nbsp;</p>
            <tr>
                <td>
		
       		<table>
             	<tr>
            		<td colspan="5" valign="top">
						<fieldset>
                			<legend>Staff Details</legend>
                				<table style="text-align:right">
                    				<tr>
                        				<td>Staff Number        
							 <script> 
							localStorage.lastname = "Matamela";
							if(localStorage.lastname=="Matamela")
							{
							  
							}
							// Retrieve
							
							</script>
							</td>
                        				<td>
		<input type="text" name="todbStaffNumber" id="todbStaffNumber" style="width:150px;" value=<%=empDetailsList.get(0).getEmpNo()%> >
							</td>
                        				<td>Name</td>
                        		<td>
		<input type="text" name="todbUsername" id="todbUsername" style="width:150px;" value="<%=empDetailsList.get(0).getName()+" "+empDetailsList.get(0).getSurname()%>">
							</td>
                        				<td></td>
                        				<td></td>
                    				</tr>
                    				<tr>
                        				<td>BU</td>
                        				<td>
                <input type="text" name="todbBusinessUnit" id="todbBusinessUnit" style="width:150px;" value="<%=buList.get(0).getBuDesc()%>">
							</td>
                        				<td>Dept </td>
                        				<td>
                <input type="text" name="todbDepartment" id="todbDepartment" value=<%=empDetailsList.get(0).getEntityOe2()%> style="width:160px;">
						         </td>
                        				<td>Competence Area</td>
                                                        <td>
		<select name="todbCompetencyArea" id="todbCompetencyArea" value="${ssDefinitionEntry.customAttributes['todbCompetencyArea'].value}" style="width:160px;">
                                                    <option> 
						    </option>
                          <%                    
								try{
                  							for (CompAreas ca : compArea) 
									 {
                        							out.println("<option>"+ca.getCompAreaAbbr()+"</option>");
           								 }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}
								catch(java.lang.IndexOutOfBoundsException iobexc)
								{
								out.println("Index Error 4: "+iobexc.getMessage());
								}
							 %>
                </select>
                			<b style="color:red">*</b>
		</td>
	                    			</tr>
                				</table>
						</fieldset>
					</td>
				</tr>
				
				<tr>
            		<td colspan="3" valign="top">
						<fieldset style="width:380px;">
            				<legend>Research Data</legend>
                  				<p>
                                 <input type="checkbox" name="researchDataLinked" id="researchDataLinked" 
                                        
				<c:if test="${ssDefinitionEntry.customAttributes['researchDataLinked'].value == 'Y'}">checked="checked"</c:if> />
                                       
                    	        Research Data (Including geospatial) is linked to this publication</p>
				<select name="todbResearchDataYN" id="todbResearchDataYN" value="${ssDefinitionEntry.customAttributes['todbResearchDataYN'].value}"style="width:150px; height: 26px;">
                                            
                                 
                                  
                                  <option>N</option>
                                  <option>Y</option>
                             </select>
           				 </fieldset>
						</p>
						<p>
            			Were rights assigned to CSIR TODB?  
            			<input type="radio" name="todbRights" id="todbRights" value="Y" 
				<c:if test="${ssDefinitionEntry.customAttributes['todbRights'].value == 'Y'}"></c:if> />Yes
				<input type="radio" name="todbRights" id="todbRights" value="N" checked="checked"
			        <c:if test="${ssDefinitionEntry.customAttributes['todbRights'].value =='N'}"></c:if> />No
         				</p>
					</td>
					
					<td colspan="2" valign="top">
						
					</td>
					
				</tr>
				
			</table>     
  </td>
</tr>
</table>


<!-- ***************************     externalPublicationsPage Tab    ****************************** -->

 <table id="externalPublicationsPage" class="hideDiv" style="width: 90%;">
         <tr><td
		<p>&nbsp;</p>
		<table>
             	<tr>
            		<td colspan="1" valign="top">Publication Type   <b style="color:red">*</b>              	
	                  <select style='width:150px' name='todbPublicationType' 
                           value="${ssDefinitionEntry.customAttributes['todbPublicationType'].value}" id="todbPublicationType">
			   <option></option>
				
                         <%                    
                                try{
                                        for (PublicationType pt : pType)
                                         {
                                            if(pt.getWfd0026TodbDocumentType().getDocumentTypeCode().equalsIgnoreCase("EXT"))
                                            {
                        %>
                         <option value="<%=pt.getReportTypeCode()%>"><%=pt.getDescription()%></option>

                        <%                  }
                                        }
                                      
                                }
                                catch (java.net.MalformedURLException mfurlexc) 
                                {

                                out.println("URL Error 2: "+mfurlexc.getMessage());
                                } 
                                catch (java.io.IOException exc) 
                                {

                                out.println("I/O Error 3: "+exc.toString());
                                }
                                 catch (java.lang.NullPointerException exc) 
                                {

                                out.println("<b><font color='red'>Service not available</font></b>");
                                }

                         %>
			</select>
 			
            
						<p>If Publication type = Other, please specify<br>
		<input type="text" name="todbOtherPublicationType" id="todbOtherPublicationType" value="${ssDefinitionEntry.customAttributes['todbOtherPublicationType'].value}" style="width:300px;"/>
					</td>
					
					<td valign="top">
						Month
            			<select name="todbMonth" id="todbMonth"style="width: 88px;" value="${ssDefinitionEntry.customAttributes['todbMonth'].value}">
                                <option></option>
                    		<option value="01">January</option>
                    		<option value="02">February</option>
                                <option value="03">March</option>
                    		<option value="04">April</option>
                                <option value="05">May</option>
                    		<option value="06">June</option>
                                <option value="07">July</option>
                    		<option value="08">August</option>
                                <option value="09">September</option>
                    		<option value="10">October</option>
                                <option value="11">November</option>
                    		<option value="12">December</option>
                                
                		</select>
					</td>
					<td colspan="1" valign="top">
                		Year
                                 <select name="todbYear" style="width: 88px;" value="${ssDefinitionEntry.customAttributes['todbYear'].value}" id="todbYear">
                                     <option></option>
                                 <%
                                       for(int i=2015; i <2025;i++)
                                        { 
                                          out.print("<option>"+i+"</option>");
					}
                                  %>
                		</select>
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<td colspan="5">    
            			Title of Journal/Title of Book/Conference proceedings<br>
            			<textarea name="todbTitleJournalBookConf" id="todbTitleJournalBookConf" style="width:300px;resize: none;">
                     </textarea>
					</td>
					
				</tr>
				<tr>
            		<td valign="top">
                            Conference Location<br>
                            <input type="text" name="todbConferenceLocation" id="todbConferenceLocation" style="width: 130px;"><br>
                            Conference Date (DDMMYYYY)<br>
                            <input type="date" name="todbconferenceDate" id="todbconferenceDate" value="<%=(new Date()).toString()%>" style="width: 130px;">
                        </td>
					
                        <td valign="top">
                                Journal Volume & No e.g 29(5)<br>
                                <input type="text" name="todbJournalVolume" id="todbJournalVolume"/><br>
                                 Page(s)e.g 1,5,8/215-240<br>
                                <input type="text" name="todbPages" id="todbPages" /><br>
                                DOI Number<br>
                                <input type="text" name="todbDoiNum" id="todbDoiNum" />
                        </td>
                        <td colspan="1" valign="top">
                            ISSN<br>
                                <input type="text" name="todbISSN" id="todbISSN" /><br>
                            ISBN<br>
                                <input type="text" name="todbISBN" id="todbISBN" /><br>
                            Status of Document  <b style="color:red">*</b><br>
                            <select name="todbStatusOfDocument" id="todbStatusOfDocument">
                                 <option></option>
                                    <option>Draft</option>
                                 <option>Submitted for Publication</option>
                                    <option>Accepted for Publication (in Press)</option>
                                 <option>Rejected</option>
                            <option>Published</option>	
                            </select>
                        </td>
                        <td>

                            <fieldset>
                                     <legend>Request to screen for IP  <b style="color:red">*</b></legend>

                             <table>
                                  <tr>
                                      <td>			
                                     Reviewed?  <b style="color:red">*</b>					
                                     </td>
                                     <td><select name="todbIPReviewedYN" id="todbIPReviewedYN">
                                            <option></option>
                                            <option value="Y">Yes</option>
                                            <option value="N">No</option>
                                        </select></td>
              </tr>
                                <tr>
                                     <td>Req.No</td>
                                     <td><input type="text" name="todbReqNo" id="todbReqNo" /></td>
                                </tr>
                                <tr>
                                     <td>Title</td>
                                     <td><input type="text" name="todbIpTitle" id="todbIpTitle" value=""/></td>
                                </tr>
                            </table>
                          </fieldset>					 
                    </td>
				</tr>
                    <tr>
                        <td>
                            Keywords<br>
                            <textarea name="todbKeyWords" id="todbKeyWords" style="width:200px;resize: none;">
                            </textarea>
                        </td>
                        <td>
                            Abstract<br>
                            <textarea name="todbAbstract" id="todbAbstract" style="width:200px;resize: none;">
                            </textarea>
                        </td>
                        <td></td>
                        <td>
                            Notes<br>
                            <textarea name="todbNotes" id="todbNotes" style="width:200px;resize: none;">
                            </textarea>
                         </td>
                        <td>

                        </td>
                    </tr>
			</table>  
</td></tr>
</table>
<!-- ***************************     External Authors List    ****************************** -->

                    <table id="externalAuthorsPage" class="hideDiv">
                            <tr><td>
                               <fieldset>
     <legend>External Author(s)</legend>
     <table border="0">
         
             <tr>
                 <td>External Signatory</td>
                 <td>Company Signatory</td>
                 
                 
             </tr>
             
             <tr>
                 <td><input type="text" name="todbAuthors1"/></td>
                
                 <td><input type="text" name="todbBU1"/></td>
                  
             </tr>
             <tr>
                 <td><input type="text" name="todbAuthors2"/></td>
                
                 <td><input type="text" name="todbBU2"/></td>
                  
             </tr><tr>
                 <td><input type="text" name="todbAuthors3"/></td>
                
                 <td><input type="text" name="todbBU3"/></td>
                  
             </tr><tr>
                 <td><input type="text" name="todbAuthors4"/></td>
                
                 <td><input type="text" name="todbBU4"/></td>
                  
             </tr><tr>
                 <td><input type="text" name="todbAuthors5"/></td>
                
                 <td><input type="text" name="todbBU5"/></td>
                  
             </tr><tr>
                 <td><input type="text" name="todbAuthors6"/></td>
                
                 <td><input type="text" name="todbBU6"/></td>
                  
             </tr>    
     </table>
  
     <table>
         <tr>
		<td colspan="2"></td>
                 <td colspan="2"></td>
         </tr>
     </table>

    </fieldset>
 </td></tr>
</table>
<!-- ***************************     Research Details Tab    ****************************** -->

<table id="researchDetailsPage" class="hideDiv">
      <tr>
        <td>
		<p>&nbsp;</p>
		
       		<table>
             	<tr>
            		<td valign="top">		
              			Source of Research Funding<b style="color:red">*</b><br>
						<select name="todbResearchFunding" style="width:150px; height: 26px" id="todbResearchFunding">
                                 <option></option>
                                 <option>Co-funding</option>
                                  <option>Contract-funding</option>
                                  <option>PG-funding</option>
                                  <option>Not Applicable</option>
                             </select>
              		</td>
					<td valign="top">
						Research Impact Areas<br>

   <!-- ***************************    Research Impact    ****************************** -->
                                            <div id="divRIA">
						<table>
                                                         <tr>
                                                             <td>
                                                                  <select name="todbRIA1" id="todbRIA1" style="width:150px; ">
									<option></option>							
									<%                    
								try{
                  							for (Ria ri : riaList)
									 {
                                                                         %>
                                                                    
                                                                     <option value=<%=ri.getRiaCode()%>> <%=ri.getDescription()%> </option>


                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                                  </td>
                                             </tr>
                                             
                                             <tr>
                                                             <td>
                                                                  <select name="todbRIA2" id="todbRIA2" style="width:150px; ">
									<option></option>								
									<%                    
								try{
                  							for (Ria ri : riaList)
									 {
                                                                         %>
                                                                    
                                                                      <option value=<%=ri.getRiaCode()%>> <%=ri.getDescription()%> </option>


                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                                  </td>
                                             </tr>
                                             
                                             <tr>
                                                             <td>
                                                                  <select name="todbRIA3" id="todbRIA3" style="width:150px; ">
                                                                    <option></option>	
																
									<%                    
								try{
                  							for (Ria ri : riaList)
									 {
                                                                         %>
                                                                    
                                                                      <option value=<%=ri.getRiaCode()%>> <%=ri.getDescription()%> </option>


                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                                  </td>
                                             </tr>

                                             <tr>
                                                             <td>
                                                                  <select name="todbRIA4" id="todbRIA4"style="width:150px; ">
						              <option></option>								
									<%                    
								try{
                  							for (Ria ri : riaList)
									 {
                                                                         %>
                                                                    
                                                                      <option value=<%=ri.getRiaCode()%>> <%=ri.getDescription()%> </option>


                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                                  </td>
                                             </tr>
                                                                       
								
                        	                  		</table>
                                                  </div>
					</td>
					<td>  
                   		Flagships<br>

<!-- ***************************    Flagship code    ****************************** -->

                                
                  		<table>  
                                        <tr>
                                            <td>
                                                <select name="todbFlagship1" id="todbFlagship1" style="width:150px; ">
                                                    <option></option>	
                      		                       <%                    
								try{
                  							for (Flagship fla : flagShipList)
									 {
                                                                         %>
                                                                       <option value=<%=fla.getFlagshipCode()%>> <%=fla.getDescription()%> </option>


                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                            </select>
                        	       </td>
                        	     </tr>

                                    <tr>
                                            <td>
                                                <select name="todbFlagship2" id="todbFlagship2" style="width:150px; ">
                                                   <option></option>	
                      		                       <%                    
								try{
                  							for (Flagship fla : flagShipList)
									 {
                                                                         %>
                                                                        <option value=<%=fla.getFlagshipCode()%>> <%=fla.getDescription()%> </option>


                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                            </select>
                        	       </td>
                        	     </tr>

                                     <tr>
                                            <td>
                                                <select name="todbFlagship3" id="todbFlagship3"style="width:150px; ">
                                                   <option></option>	
                      		                       <%                    
								try{
                  							for (Flagship fla : flagShipList)
									 {
                                                                         %>
                                                                       <option value=<%=fla.getFlagshipCode()%>> <%=fla.getDescription()%> </option>
                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                            </select>
                        	       </td>
                        	     </tr>

                                     <tr>
                                            <td>
                                                <select name="todbFlagship4" id="todbFlagship4" style="width:150px; ">
                                                     <option></option>	
                      		                       <%                    
								try{
                  							for (Flagship fla : flagShipList)
									 {
                                                                         %>
                                                                       <option value=<%=fla.getFlagshipCode()%>> <%=fla.getDescription()%> </option>
                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}

							 %>
                                            </select>
                        	       </td>
                        	     </tr>
                  		</table>
					</td>
				</tr>
				<tr>
					<td>
<!-- ***************************     Project Number code    ****************************** -->
                      	<p>Project Number</p>
				<table>
                      		<tr>
				   <td> 
                                       <select name="todbProjectCode1" id="todbProjectCode1" style="width:150px;" onchange="loadProjectDesc('todbProjectCode1','todbProjectDescription1');">
                                           <option></option> 
                                           <%
                                                try{
                  							for (ProjectId pro : proIDs)
									 {
                                                                         %>
                                                                            <option value="<%=pro.getProjectDescription()%>"> <%=pro.getProjectId()%> </option>
                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}
                                           %>
                                       </select>
								
								</td>
								<td>
								</td>
                                </tr>
                        <tr>
                           <td>
				<select name="todbProjectCode2" id="todbProjectCode2" style="width:150px;" onchange="loadProjectDesc('todbProjectCode2','todbProjectDescription2');">
                                    <option></option> 
                                    <%
                                         try{
                                                 for (ProjectId pro : proIDs)
                                                  {
                                                  %>
                                                     <option value="<%=pro.getProjectDescription()%>"> <%=pro.getProjectId()%> </option>
                                                  <%
                                                  }
                                             }
                                             catch (java.net.MalformedURLException mfurlexc) 
                                             {

                                             out.println("URL Error 2: "+mfurlexc.getMessage());
                                             } 
                                             catch (java.io.IOException exc) 
                                             {

                                             out.println("I/O Error 3: "+exc.toString());
                                             }
                                              catch (java.lang.NullPointerException exc) 
                                             {

                                             out.println("<b><font color='red'>Service not available</font></b>");
                                             }
                                    %>
                                </select>
								</td>
								<td>
								</td>
                        </tr>
                         <tr>
                          <td>
								 <select name="todbProjectCode3" id="todbProjectCode3" style="width:150px; " onchange="loadProjectDesc('todbProjectCode3','todbProjectDescription3');">
                                           <option></option> 
                                           <%
                                                try{
                  							for (ProjectId pro : proIDs)
									 {
                                                                         %>
                                                                            <option value="<%=pro.getProjectDescription()%>"> <%=pro.getProjectId()%> </option>
                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}
                                           %>
                                       </select>
								</td>
								<td>
								</td>
                         </tr>
                          <tr>
                             <td>
								 <select name="todbProjectCode4" id="todbProjectCode4" style="width:150px; " onchange="loadProjectDesc('todbProjectCode4','todbProjectDescription4');">
                                           <option></option> 
                                           <%
                                                try{
                  							for (ProjectId pro : proIDs)
									 {
                                                                         %>
                                                                            <option value="<%=pro.getProjectDescription()%>"> <%=pro.getProjectId()%> </option>
                                                                         <%
                                                                         }
								   }
								catch (java.net.MalformedURLException mfurlexc) 
								{
			
								out.println("URL Error 2: "+mfurlexc.getMessage());
								} 
								catch (java.io.IOException exc) 
								{
			
								out.println("I/O Error 3: "+exc.toString());
								}
                                                                 catch (java.lang.NullPointerException exc) 
								{
			
								out.println("<b><font color='red'>Service not available</font></b>");
								}
                                           %>
                                       </select>
								</td>
								<td>
								</td>
                          </tr>
                  		</table>
					</td>
					<td colspan="2">
						<p>&nbsp;</p>
                   		<table>
                      		<tr>
							<td><input type="text" name="todbProjectDescription1" id="todbProjectDescription1" value="${ssDefinitionEntry.customAttributes['todbProjectCode1'].value}" style="width: 500px;" readonly="true"/></td></tr>
                        	<tr>
							<td><input type="text" name="todbProjectDescription2" id="todbProjectDescription2" value="${ssDefinitionEntry.customAttributes['todbProjectCode2'].value}" style="width: 500px;" readonly="true"/></td></tr>
                         	<tr>
							<td><input type="text" name="todbProjectDescription3" id="todbProjectDescription3" value="${ssDefinitionEntry.customAttributes['todbProjectCode3'].value}" style="width: 500px;" readonly="true"/></td></tr>
                          	<tr>
							<td><input type="text" name="todbProjectDescription4" id="todbProjectDescription4" value="${ssDefinitionEntry.customAttributes['todbProjectCode4'].value}" style="width: 500px;" readonly="true"/></td></tr>
                  		</table>
					</td>
				</tr>
			</table>
		                      
   </td>
  </tr>
</table> <br/><br/>
                <input type="submit" class="custom_submit" name="okBtn" value="Next" onClick="validateform();"/>
		<input type="submit" class="custom_submit" name="cancelBtn" value="Cancel" onClick="ss_buttonSelect('cancelBtn'); " />  
                






/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Ntando Zungu
 */
import java.io.*;
import  java.net.*;
import org.json.JSONArray;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.GenericType;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.client.filter.HTTPBasicAuthFilter;
import com.sun.jersey.api.json.JSONConfiguration;
import com.sun.jersey.client.urlconnection.HTTPSProperties;
import com.todb.model.*;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.ws.rs.core.MultivaluedMap;
import org.codehaus.jackson.jaxrs.JacksonJaxbJsonProvider;
import org.dom4j.Document;
import org.kablink.teaming.domain.Description;
import org.kablink.teaming.domain.FolderEntry;
import org.kablink.teaming.domain.User;
import org.kablink.teaming.domain.WorkflowState;
import org.kablink.teaming.domain.WorkflowSupport;
import org.kablink.teaming.module.binder.BinderModule;
import org.kablink.teaming.module.workflow.support.AbstractWorkflowCallout;
import org.kablink.teaming.module.workflow.support.WorkflowAction;
import org.kablink.teaming.rest.v1.model.FolderEntryBrief;
import org.kablink.teaming.rest.v1.model.ParentBinder;

import org.kablink.teaming.util.ResolveIds;
import org.kablink.teaming.web.util.WebUrlUtil;

public class ToDBWorkflowCall extends AbstractWorkflowCallout implements WorkflowAction {

    @Override
    public void execute(WorkflowSupport entry, WorkflowState state) 
    {
            // TODO Auto-generated method stub
            System.out.println("Hello World!"); 
            // Check to see if this is a FolderEntry
        if (entry instanceof FolderEntry) 
        {
            System.out.println("Inside the if condition");
            FolderEntry fe = (FolderEntry)entry;
            System.out.println("After declaring FolderEntry");

            fe.addCustomAttribute("docID", fe.getId().toString());

            Long entryId = entry.getOwnerId();
            System.out.println("After getting owner ID");
            Description desc = fe.getDescription();
            System.out.println("After getting entry description");
            Long binderId = fe.getParentBinder().getId();
            System.out.println("After getting parent binder ID");


            System.out.println(" Changed Workflow State to:" + state.getState());
            System.out.println(" Binder Id:" + binderId.toString());
            System.out.println(" Owner Id:" + entryId.toString());
            System.out.println(" Entry Id:" + fe.getId().toString());

            if(desc != null)
            System.out.println(" Description:" +  desc.getStrippedText()); 

            if(state.getState().equals("csirTODBSubmittedEntry"))
            {

                FolderEntry folderEntry = (FolderEntry)entry;

                //Business units used to populate fields
                if(folderEntry.getCustomAttribute("todbRights").getValue().equals("Y") || folderEntry.getCustomAttribute("todbRights").getValue()=="Y")
                {
                    System.out.println("Input read from ToDB Rights: "+ folderEntry.getCustomAttribute("todbRights").getValue());
                    System.out.println("DOC TYPE: "+ folderEntry.getCustomAttribute("todbDoctype").getValue().toString());
                    System.out.println("todbCompetencyAreas for Today:  "+folderEntry.getCustomAttribute("todbCompetencyArea").getValue().toString());

                    com.sun.jersey.api.client.ClientResponse cresponse = null;
                    List<EntityIdent> empDetails=null;
                    String username = "user";
                    String password = "password";
                    String t = null;

                    /*Document defDoc = (Document) request.getAttribute("ssConfigDefinition");*/
                    String titleName = folderEntry.getTitle();
                    String docType=folderEntry.getCustomAttribute("todbDoctype").getValue().toString();
                    String todbRIA1="@",todbRIA2="@",todbRIA3="@",todbRIA4 ="@";
                    System.out.println("Read doc type");

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

                        WebResource resource = todbclient.resource("https://mule-test.csir.co.za/api/todb/");


                        com.todb.model.TODBRequest todbRequestContainer = new com.todb.model.TODBRequest();
                        Request todbrequest = new Request();
                        java.util.List<com.todb.model.CSIRAuthors> authors = new java.util.ArrayList();
                        java.util.List<com.todb.model.ReqRia> ril = new java.util.ArrayList();
                        java.util.List<com.todb.model.ReqFlagship> fl = new java.util.ArrayList();
                        java.util.List<com.todb.model.ReqProject> rpl = new java.util.ArrayList();


                        todbrequest.setEmpNo(folderEntry.getCustomAttribute("todbStaffNumber").getValue().toString());
                            System.out.println("Staff Number 1");
                        todbrequest.setRequestDateTime(new Date());
                        todbrequest.setRequestorEmpNo(folderEntry.getCustomAttribute("todbStaffNumber").getValue().toString());
                            System.out.println("Staff Number 2");
                        todbrequest.setRequestorName(folderEntry.getCustomAttribute("todbUsername").getValue().toString());
                            System.out.println("Username");

                        todbrequest.setDocTypeCode(docType);
                        todbrequest.setStatusInd("SUBMITTED");
                        todbrequest.setGwDocNo("12345");
                        todbrequest.setGwLibrary("PTA PROJECTS TEST FORM");
                        todbrequest.setTodbAssignViewRightsYn(folderEntry.getCustomAttribute("todbRights").getValue().toString());
                            System.out.println("Read ToDB Rights");
                        todbrequest.setCompetenceArea(folderEntry.getCustomAttribute("todbCompetencyArea").getValue().toString());
                            System.out.println("Read Comp Area");
                        todbrequest.setFundingCode(folderEntry.getCustomAttribute("todbResearchFunding").getValue().toString());
                            System.out.println("Read Research Funding");
                        todbrequest.setRiaCode("L");
                        todbrequest.setTodbIndexingYn("N");
                        todbrequest.setResearchDataYn(folderEntry.getCustomAttribute("todbResearchDataYN").getValue().toString());
                            System.out.println("Read Research Data Y/N");
                        //Map mymap =  folderEntry.getCustomAttributes();
                        //for(Object key:mymap.keySet())
                        //{
//                        BinderModule binm=null;
//                        binm.getSimpleName(t);
                        //Document doc = folderEntry.getEntryDefDoc();
                         FolderEntryBrief feb = new FolderEntryBrief();
                            //feb.setDefinitionId(folderEntry.getId());
                            feb.setId(folderEntry.getId());
                            //feb.setParentBinder((ParentBinder)folderEntry.getParentBinder());
                            String entryLink = WebUrlUtil.getEntryViewURL(fe);
                            System.out.println("Inserting permalink:     "+entryLink);//folderEntry.getCreatedWithDefinitionDoc().getUniquePath());//doc.getRootElement().getData().toString());
                           
                            //String titleName1111 = (String) defDoc.getRootElement().attributeValue("caption");
                        //todbrequest.setPermaLink(folderEntry.getEntryDefDoc().getRootElement().getNamespaceURI());
                        //}
                        //todbrequest.setVibeDocId(folderEntry.getCustomAttribute("docID").getValue().toString());
                        //System.out.println("Read Doc ID: "+folderEntry.getCustomAttribute("docID").getValue().toString());
                        System.out.println("_______________TESTING CSIR AUTHORS_______________");
                        Set myset = folderEntry.getCustomAttribute("csirAuthors").getValueSet();
                        Iterator iter = ResolveIds.getPrincipals(myset, false).iterator(); //idnames =new ResolveIds();

                        System.out.println("Here are all the elements in the entry:");
                        if(myset.isEmpty() == false)//if there are selected CSIR authors
                        {
                            String lanID;
                            com.todb.model.CSIRAuthors csirauthor;
                            while(iter.hasNext())//insert all selected authors to request
                            {
                                System.out.println("Authors not empty");
                                lanID = iter.next().toString();
                                System.out.println("Before URL access | "+lanID);
                                cresponse = resource.path("employees/"+lanID.toUpperCase()).accept("application/json").get(ClientResponse.class);
                                System.out.println("After URL access | "+lanID);
                                //empDetailsList = new ArrayList();
                                empDetails = cresponse.getEntity(new GenericType<List<EntityIdent>>() {});
                                System.out.println("CSIR AUTHOR Found:    "+empDetails.size());
                                //empDetailsList = cresponse.getEntity(new GenericType<List<EntityIdent>>() {});
                                //System.out.println("Retrieved employee number: "+empDetailsList.get(0).getEmpNo());
                                //User todbuser;
                                if(empDetails.size() > 0)
                                {
                                    System.out.println("Inside the if condition.......................");
                                    csirauthor = new com.todb.model.CSIRAuthors();
                                    System.out.println("Before reading Employee number");
                                    com.todb.model.CSIRAuthorsPK au1 = new com.todb.model.CSIRAuthorsPK(empDetails.get(0).getEmpNo());
                                    System.out.println("After reading Employee number");
                                    csirauthor.setCsirAuthorsPK(au1);
                                    csirauthor.setInsertUser(lanID.toUpperCase());
                                    csirauthor.setInsertDate(new Date());
                                    System.out.println("Inserting PGM Name: "+empDetails.get(0).getInsertUser());
                                    csirauthor.setInsertPgmName(empDetails.get(0).getInsertUser());
                                    authors.add(csirauthor);
                                    System.out.println("Inserted:    "+lanID);
                                }
                            }
                        }

                        System.out.println(authors.size()+" CSIR authors were added.....");

                        com.todb.model.ResearchData rdata = new com.todb.model.ResearchData();
                        rdata.setResponsibilityCode("1");

                       if(folderEntry.getCustomAttribute("todbRIA1").getValue()!="")
                       {
                            todbRIA1=folderEntry.getCustomAttribute("todbRIA1").getValue().toString();
                            if(todbRIA1.isEmpty()==false)
                            {
                                com.todb.model.ReqRia r1 = new com.todb.model.ReqRia();
                                r1.setRiaCode(todbRIA1);
                                ril.add(r1);
                            }
                       }
                       if(folderEntry.getCustomAttribute("todbRIA2").getValue()!="")
                       {
                            System.out.println("todbRIA2: "+folderEntry.getCustomAttribute("todbRIA2").getValue());
                            if(todbRIA1.isEmpty()==false)
                            {
                                todbRIA2=folderEntry.getCustomAttribute("todbRIA2").getValue().toString();
                                ReqRia r2 = new com.todb.model.ReqRia();
                                r2.setRiaCode(todbRIA2);
                                ril.add(r2);
                            } 
                       }
                       if(folderEntry.getCustomAttribute("todbRIA3").getValue()!="")
                       {
                            if(todbRIA1.isEmpty()==false)
                            {
                                todbRIA3=folderEntry.getCustomAttribute("todbRIA3").getValue().toString();
                                com.todb.model.ReqRia r3 = new com.todb.model.ReqRia();
                                r3.setRiaCode(todbRIA3);
                                ril.add(r3);
                            }
                       }
                       if(folderEntry.getCustomAttribute("todbRIA4").getValue()!="")
                       {
                            if(todbRIA1.isEmpty()==false)
                            {
                                todbRIA4=folderEntry.getCustomAttribute("todbRIA4").getValue().toString();
                                com.todb.model.ReqRia r4 = new com.todb.model.ReqRia();
                                r4.setRiaCode(todbRIA4);
                                ril.add(r4);
                            }
                       }

                        if(folderEntry.getCustomAttribute("todbFlagship1").getValue()!="")
                        {
                            com.todb.model.ReqFlagship rf = new com.todb.model.ReqFlagship();
                            rf.setFlagshipCode(folderEntry.getCustomAttribute("todbFlagship1").getValue().toString());
                            fl.add(rf);
                        }
                        if(folderEntry.getCustomAttribute("todbFlagship2").getValue()!="")
                        {
                            com.todb.model.ReqFlagship rf = new com.todb.model.ReqFlagship();
                            rf.setFlagshipCode(folderEntry.getCustomAttribute("todbFlagship2").getValue().toString());
                            fl.add(rf);
                        }
                        if(folderEntry.getCustomAttribute("todbFlagship3").getValue()!="")
                        {
                            com.todb.model.ReqFlagship rf = new com.todb.model.ReqFlagship();
                            rf.setFlagshipCode(folderEntry.getCustomAttribute("todbFlagship3").getValue().toString());
                            fl.add(rf);
                        }
                        if(folderEntry.getCustomAttribute("todbFlagship4").getValue()!="")
                        {
                            com.todb.model.ReqFlagship rf = new com.todb.model.ReqFlagship();
                            rf.setFlagshipCode(folderEntry.getCustomAttribute("todbFlagship4").getValue().toString());
                            fl.add(rf);
                        }

                        if(folderEntry.getCustomAttribute("todbProjectCode1").getValue()!="")
                        {
                            System.out.println("Inserting Proj ID: "+folderEntry.getCustomAttribute("todbProjectCode1").getValue().toString());
                            com.todb.model.ReqProject pid1 = new com.todb.model.ReqProject();
                            pid1.setProjectId(folderEntry.getCustomAttribute("todbProjectCode1").getValue().toString());
                            rpl.add(pid1);
                        }
                        if(folderEntry.getCustomAttribute("todbProjectCode2").getValue()!="")
                        {
                            System.out.println("Inserting Proj ID: "+folderEntry.getCustomAttribute("todbProjectCode2").getValue().toString());
                            com.todb.model.ReqProject pid2 = new com.todb.model.ReqProject();
                            pid2.setProjectId(folderEntry.getCustomAttribute("todbProjectCode2").getValue().toString());
                            rpl.add(pid2);
                        }
                        if(folderEntry.getCustomAttribute("todbProjectCode2").getValue()!="")
                        {
                            System.out.println("Inserting Proj ID: "+folderEntry.getCustomAttribute("todbProjectCode3").getValue().toString());
                            com.todb.model.ReqProject pid3 = new com.todb.model.ReqProject();
                            pid3.setProjectId(folderEntry.getCustomAttribute("todbProjectCode3").getValue().toString());
                            rpl.add(pid3);
                        }
                        if(folderEntry.getCustomAttribute("todbProjectCode2").getValue()!="")
                        {
                            System.out.println("Inserting Proj ID: "+folderEntry.getCustomAttribute("todbProjectCode4").getValue().toString());
                            com.todb.model.ReqProject pid4 = new com.todb.model.ReqProject();
                            pid4.setProjectId(folderEntry.getCustomAttribute("todbProjectCode4").getValue().toString());
                            rpl.add(pid4);
                        }

                        if(docType=="LEG"||docType.equals("LEG"))
                       {
                            System.out.println("LEG");
                            todbrequest.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            System.out.println("Security Classification");

                            com.todb.model.LegalDocReqs legDoc = new com.todb.model.LegalDocReqs();
                            legDoc.setAbstract1(folderEntry.getCustomAttribute("todbAbstract").getValue().toString());
                            legDoc.setNotes(folderEntry.getCustomAttribute("todbNotes").getValue().toString());
                            legDoc.setKeywords(folderEntry.getCustomAttribute("todbKeyWords").getValue().toString());
                            legDoc.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            legDoc.setSignedDate(new Date());
                            legDoc.setPublicationType(folderEntry.getCustomAttribute("todbPublicationType").getValue().toString());
                            legDoc.setDuration(folderEntry.getCustomAttribute("todbDuration").getValue().toString());
                            legDoc.setCompanyOfSignatory("N/A");/////////////////////////////////////////////////////////////remove hardcoding
                            legDoc.setDocumentTitle("NONE");/////////////////////////////////////////////////////////////////remove hardcoding
                            legDoc.setInsertPgmName("45");///////////////////////////////////////////////////////////////////remove hardcoding
                            legDoc.setProjectProposalNo(folderEntry.getCustomAttribute("todbProjectProposal").getValue().toString());
                            legDoc.setInsertUser(folderEntry.getCustomAttribute("todbStaffNumber").getValue().toString());
                            todbRequestContainer.setLegal(legDoc);
                       }
                       if(docType=="EXT"||docType.equals("EXT"))
                       {
                            System.out.println("EXT");
                            ExtPubReqs extPub=new ExtPubReqs();
                            extPub.setAbstract1(folderEntry.getCustomAttribute("todbAbstract").getValue().toString());
                            extPub.setKeywords(folderEntry.getCustomAttribute("todbKeyWords").getValue().toString());
                            extPub.setNotes(folderEntry.getCustomAttribute("todbNotes").getValue().toString());
                            extPub.setDoiNumber(folderEntry.getCustomAttribute("todbDoiNum").getValue().toString());
                            extPub.setMonth(folderEntry.getCustomAttribute("todbMonth").getValue().toString());
                            extPub.setIsbn(folderEntry.getCustomAttribute("todbISBN").getValue().toString());
                            extPub.setIssn(folderEntry.getCustomAttribute("todbISSN").getValue().toString());
                            extPub.setExternalAuthor(folderEntry.getCustomAttribute("csirAuthors").getValue().toString());
                            extPub.setInsertPgmName("WFD0026_F001");/////////////////////////////////////////////////////////remove hardcoding
                            extPub.setYear(folderEntry.getCustomAttribute("todbYear").getValue().toString());
                            extPub.setDocumentTitle(titleName);
                            extPub.setDocumentStatus(folderEntry.getCustomAttribute("todbStatusOfDocument").getValue().toString());
                            extPub.setIpApprovedYn("Y");///////////////////////////////////////////////////////////////////////remove hardcoding
                            extPub.setInsertDate(new Date());
                            extPub.setPublicationType(folderEntry.getCustomAttribute("todbPublicationType").getValue().toString());
                            extPub.setIpTitle(folderEntry.getCustomAttribute("todbIpTitle").getValue().toString());
                            extPub.setIpRequestNo(folderEntry.getCustomAttribute("todbReqNo").getValue().toString());
                            extPub.setConferenceLocationDate(folderEntry.getCustomAttribute("todbConferenceLocation").getValue().toString());
                            com.todb.model.IpepRequest ip=new com.todb.model.IpepRequest();
                            ip.setIpepTitle("my");/////////////////////////////////////////////////////////////////////////////remove hardcoding
                            ip.setRequestNo(folderEntry.getCustomAttribute("todbStaffNumber").getValue().toString());
                            ip.setIpepTitle("Text");///////////////////////////////////////////////////////////////////////////remove hardcoding
                            todbRequestContainer.setExtPub(extPub);
                       }

                       if(docType=="REP"||docType.equals("REP"))
                       {   
                            System.out.println("REP");
                            todbrequest.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            System.out.println("Security Classification");
                            com.todb.model.RepTechReqs reptech = new com.todb.model.RepTechReqs();
                            reptech.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            reptech.setDocumentTitle(titleName);
                            reptech.setPublicationType(folderEntry.getCustomAttribute("todbPublicationType").getValue().toString());
                            reptech.setKeywords(folderEntry.getCustomAttribute("todbKeyWords").getValue().toString());
                            reptech.setAbstract1(folderEntry.getCustomAttribute("todbAbstract").getValue().toString());
                            reptech.setNotes(folderEntry.getCustomAttribute("todbNotes").getValue().toString());
                            reptech.setInsertUser(folderEntry.getCustomAttribute("todbUsername").getValue().toString());
                            reptech.setInsertDate(new Date());
                            reptech.setInsertPgmName("WFD0026_F001");//////////////////////////////////////////////////////////////remove hardcoding
                            reptech.setMonth(folderEntry.getCustomAttribute("todbMonth").getValue().toString());
                            reptech.setYear(folderEntry.getCustomAttribute("todbYear").getValue().toString());
                            reptech.setProjectId(folderEntry.getCustomAttribute("todbProjectCode1").getValue().toString());

                            todbRequestContainer.setRepTech(reptech);
                       }
                       if(docType=="MIS"||docType.equals("MIS"))
                       {

                            System.out.println("MIS");
                            //System.out.println("DefinableEntity Class Path: "+DefinableEntity.class.getCanonicalName());

                            todbrequest.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            System.out.println("Security Classification");

                            MiscDocReqs misc=new MiscDocReqs();
                            //misc.setRequestNo("34");////////////////////////////////////////////////////////////////////////remove hardcoding
                            misc.setPublicationType(folderEntry.getCustomAttribute("todbPublicationType").getValue().toString());
                            misc.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            misc.setClientName(folderEntry.getCustomAttribute("todbClientName").getValue().toString());
                            misc.setDocumentTitle(titleName);
                            misc.setMonth(folderEntry.getCustomAttribute("todbMonth").getValue().toString());

                            misc.setYear(folderEntry.getCustomAttribute("todbYear").getValue().toString());
                            misc.setNotes(folderEntry.getCustomAttribute("todbNotes").getValue().toString());
                            misc.setAbstract1(folderEntry.getCustomAttribute("todbAbstract").getValue().toString());
                            misc.setKeywords(folderEntry.getCustomAttribute("todbKeywords").getValue().toString());
                            misc.setInsertUser(folderEntry.getCustomAttribute("todbUsername").getValue().toString());
                            misc.setInsertDate(new Date());
                           // misc.setInsertPgmName("305118");

                            todbRequestContainer.setMisDoc(misc);
                       }
                       if(docType=="THE"||docType.equals("THE"))
                       {
                            System.out.println("THE");
                            todbrequest.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            System.out.println("Security Classification");
                            TheDisReqs thes=new TheDisReqs();
                            thes.setAbstract1(folderEntry.getCustomAttribute("todbAbstract").getValue().toString());
                            thes.setAcademicInstitution(folderEntry.getCustomAttribute("todbAcademicInstitution").getValue().toString());
                            thes.setDocumentTitle(titleName);
                            thes.setInsertDate(new Date());
                            thes.setInsertPgmName(username);
                            thes.setInsertUser(folderEntry.getCustomAttribute("todbUsername").getValue().toString());
                            thes.setKeywords(folderEntry.getCustomAttribute("todbKeywords").getValue().toString());
                            thes.setNotes(folderEntry.getCustomAttribute("todbNotes").getValue().toString());
                            thes.setMonth(folderEntry.getCustomAttribute("todbMonth").getValue().toString());

                            thes.setPublTypeOther(folderEntry.getCustomAttribute("todbOtherPublicationType").getValue().toString());
                            thes.setPublicationType(folderEntry.getCustomAttribute("todbPublicationType").getValue().toString());
                            //thes.setRequestNo("786");////////////////////////////////////////////////////////////////////////remove hardcoding
                            thes.setSecurityClassification(folderEntry.getCustomAttribute("todbSecurityClassification").getValue().toString());
                            thes.setYear(folderEntry.getCustomAttribute("todbYear").getValue().toString());
                            todbRequestContainer.setTheDis(thes);
                       }

                        todbRequestContainer.setProj(rpl);
                        todbRequestContainer.setAuthors(authors);
                        todbRequestContainer.setResearch(rdata);
                        todbRequestContainer.setRequest(todbrequest);
                        todbRequestContainer.setFlag(fl);
                        if(ril.size()>0)//check if there are RIAs to append to request
                        {
                            todbRequestContainer.setRia(ril);
                        }
                        todbRequestContainer.setProj(rpl);
                        //todbRequestContainer.setExtAuth(ea);

                        String postURL = "https://mule-test.csir.co.za/api/todb/createrequest";

                        System.out.println("NOW COMMITTING DATA INTO DATABASE.................");
                        //to submit to the ToDB 
                        WebResource webResourcePost = todbclient.resource(postURL);
                        cresponse = webResourcePost.type("application/json").post(ClientResponse.class, todbRequestContainer);
                            System.out.println("STATUS: "+cresponse.getStatus());
                        if (cresponse.getStatus() == 200) {
                            Request req = cresponse.getEntity(Request.class);
                            folderEntry.addCustomAttribute("todbRefNum", req.getTodbPublicationNo());
                            folderEntry.addCustomAttribute("todbCheckIfCommitted", "Yes");
                            System.out.println("Success");

                        } else {
                            System.out.println("FAILED TO COMMIT!!!!!!");
                            com.todb.model.ErrorResponse exc = cresponse.getEntity(com.todb.model.ErrorResponse.class);
                            System.out.println("Error code: "+exc.getErrorCode());
                            System.out.println("Error ID: "+exc.getErrorId());
                            //exc.printStackTrace();
                        } 
                    }
                    catch (java.lang.NullPointerException npexc) {npexc.printStackTrace();}
                    catch (Exception e) {t = e.getMessage();}

                }
            }
        }
    }
}

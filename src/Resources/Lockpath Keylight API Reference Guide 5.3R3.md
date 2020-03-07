APIReferenceGuide


```
KeylightAPI | APIReferenceGuide
```
ThispublicationwaswrittenandproducedatLockpath,Inc.,OverlandPark,Kansas.Thispublicationoranyportion
thereofisconfidentialand/orproprietaryandmaynotbereproducedorusedinanymannerwhatsoeverwithoutthe
expresswrittenpermissionofLockpath,Inc.
©2010- 2020 Lockpath,Inc.Allrightsreserved.Lockpath®,theLockpathiconTM,DynamicContentFrameworkTMand
Keylight®aretrademarksofLockpath,Inc.andareregisteredintheUnitedStates.Thetrademarksandnamesofother
companiesandproductsmentionedhereinarethepropertyoftheirrespectiveowners.
LastUpdated:December 2019
Version:5.


## Contents

```
AboutThisGuide
```

APPENDICES


**C: Filtering**

```
SearchFilters 159
```
**D: LanguageIdentifiers**
LanguageIDs 166

**E: TroubleshootingTips**

```
APITroubleshooting 169
KeylightAPIFAQ 171
```

AboutThisGuide

ThisguideprovidesthesyntaxforthevariousRESTful APIverbs.ThisguideisintendedforIT professionalsand
KeylightadministratorswhoareresponsibleforimportingandexportingdatatoandfromtheKeylightPlatformusing
theKeylightAPIapplication.
Thisguidecontainsthefollowingchaptersandappendices.

```
Introduction Providesalistofthemethodsusedforintegratingexternaldatawiththe
KeylightPlatformandtherulesforusingtheKeylightAPI.
SecurityServicesAPI ProvidestheLoginandLogoutmethodsforlogginginandloggingoutofthe
KeylightPlatformandmethodsforgetting,creating,updating,anddeleting
usersandgroups.
ComponentServicesAPI Providestheavailablemethodsforposting,getting,anddeletingdatafromthe
KeylightPlatform,includingexamplesofeach.
FieldTypes ProvidesalistingofthevalidIDnumberforthevariousfieldtypesinthe
KeylightPlatform.
cURLCommandSwitches ProvidesalistingofbasiccURLcommandswitches.
Filtering Providethesyntaxforsearchfilters,fieldpaths,filtertypes,values,search
criteriaitem,includingexamplesforeach.
LanguageIdentifiers Providesalistoflanguageidentifiersandcorrespondinglanguagenames
availableintheKeylightPlatform.
TroubleshootingTips Providestroubleshootingtipsandfrequentlyaskedquestionsforanyissues
thatmayoccurrelatedtoREST API.
```

```
ThischapterprovidesanoverviewtotheApplicationProgramInterfacewiththemethodsandcallsfortheKeylight
Platform.
KeylightAPIBasics 6
RulestoKeylightAPI 9
```
1:Introduction


## KeylightAPIBasics

TheApplicationProgrammingInterface(API)providesaccesstoasetofRepresentationalStateTransfer(REST)
APIsthatallowsaccessandintegrationtocustomuser-createddatacomponentsstoredintheKeylightPlatform.
SupportedmethodsareGET,POST,andDELETE.

```
Call Description
Login Acceptsanaccountusernameandpassword,verifiesthemwithinKeylightand
providesanencryptedcookiethatcanbeusedtoauthenticateadditionalAPI
transactions.
Ping RefreshesavalidKeylightPlatformsession.
Logout TerminatesaKeylightPlatformsession.
GetUser Returnsallfieldsforagivenuser.
GetUsers Returnsusersandsupportingfields.Filtersmaybeappliedtoreturnonlythe
usersmeetingselectedcriteria.
GetUserCount Returnsacountofusers.Filterscanbeappliedtoreturnonlytheusersmeeting
selectedcriteria.
CreateUser Createauseraccount.
UpdateUser Updateauseraccount.
DeleteUser Deleteauseraccount.
GetGroup Returnsallfieldsforagivengroup.
GetGroups ReturnstheIDandNameforgroups.Afiltermaybeappliedtoreturnonlythe
groupsmeetingselectedcriteria.
CreateGroup Createsagroup.
UpdateGroup Updatesagroup.
DeleteGroup Deleteagroup.
GetComponent RetrievesacomponentspecifiedbyitsID.Acomponentisauser-defineddata
objectsuchasacustomcontenttable.ThecomponentIDmaybefoundby
usingGetComponentList.
GetComponentList ReturnsacompletelistofallKeylightcomponentsavailabletotheuserbased
onaccountpermissions.Noinputelementsareused.Thelistwillbeorderedin
ascendingalphabeticalorderofthecomponentname.
GetComponentByAlias RetrievesacomponentspecifiedbyitsAlias.Acomponentisauser-defined
dataobjectsuchasacustomcontenttable.ThecomponentAliasmaybefound
byusingGetComponentList(ShortName).
GetField RetrievesdetailsforafieldspecifiedbyitsID.ThefieldIDmaybefoundby
usingGetFieldList.
```

**Call Description**
GetFieldList RetrievesdetailfieldlistingforacomponentspecifiedbyitsID.Thecomponent
IDmaybefoundbyusingGetComponentList.DocumentsorAssessments
fieldtypeswillnotbevisibleinthislist.
GetAvailableLookupRecords Retrievesrecordsthatareavailableforpopulationforalookupfield.
GetLookupReportColumnFields Getsthefieldinformationofeachfieldinafieldpaththatcorrespondstoa
lookupreportcolumn.ThelookupFieldIdcorrespondstoalookupfieldwitha
reportdefinitiononitandthefieldPathIdcorrespondstothefieldpathtoretrieve
fieldsfrom,whichisobtainedfromGetDetailRecord.
GetLookupReportColumnFieldscomplimentsGetRecordDetailbyadding
additionaldetailsaboutthelookupreportcolumnsreturnedfrom
GetRecordDetail.
GetRecord Returnsthecompletesetoffieldsforagivenrecordwithinacomponent.
GetRecords Returnsthetitle/defaultfieldforasetofrecordswithinachosencomponent.
Filtersmaybeappliedtoreturnonlytherecordsmeetingselectedcriteria.
GetRecordCount Returnsthenumberofrecordsinagivencomponent.Filtersmaybeappliedto
returnthecountofrecordsmeetingagivencriteria.Thisfunctionmaybeused
tohelpdeterminetheamountofrecordsbeforeretrievingtherecords
themselves.
GetDetailRecord RetrievesrecordinformationbasedontheprovidedcomponentIDandrecord
ID,withlookupfieldreportdetails.Lookupfieldrecordswilldetailinformationfor
fieldsontheirreportdefinition,ifonisdefined.
GetDetailRecords GetDetailRecordsprovidestheabilitytorunasearchwithfiltersandpaging
(GetRecords)whilereturningahighlevelofdetailforeachrecord(GetRecord).
GetDetailRecordsalsoallowsmultiplesortstomodifytheorderoftheresults.
Forperformanceandsecurityconcerns,themaximumnumberofrecords
returned(pageSize)is1000.
GetRecordAttachment GetsasingleattachmentassociatedwiththeprovidedcomponentID,record
ID,documentsfieldID,anddocumentID.Thefilecontentsarereturnedasa
Base64string.
GetRecordAttachments Getsinformationforallattachmentsassociatedwiththeprovidedcomponent
ID,recordID,andDocumentsfieldid.Nofiledataisreturned,onlyfilename,
fieldID,anddocumentIDinformation.
GetWorkflow RetrievesworkflowdetailsandallworkflowstagesspecifiedbyID.TheIDfora
workflowmaybefoundbyusingGetWorkflows.
GetWorkflows RetrievesallworkflowsforacomponentspecifiedbyitsAlias.Acomponentis
auser-defineddataobjectsuchasacustomcontenttable.Thecomponent
AliasmaybefoundbyusingGetComponentList(ShortName).
TransitionRecord Transitionarecordinaworkflowstage.


**Call Description**
VoteRecord Castavoteforarecordinaworkflowstage.
CreateRecord CreatesanewrecordwithinthespecifiedcomponentoftheKeylight
application.NotethattheRequiredoptionforafieldinKeylightisonlyenforced
throughtheuserinterface,notthroughtheAPI.Therefore,CreateRecorddoes
notenforcetheRequiredoptionforfields.
UpdateRecord Updatesfieldswithinaspecifiedrecord.NotethattheRequiredoptionforafield
intheKeylightPlatformisonlyenforcedthroughtheuserinterface,notthrough
theAPI.Therefore,UpdateRecorddoesnotenforcetheRequiredoptionfor
fields.Theresponsewillincludethecompletesetoffieldsforthegivenrecord.
UpdateRecordAttachments Addsnewattachmentsand/orupdatesexistingattachmentstotheprovided
Documentsfield(s)onaspecificrecord,wheretheFileDataisrepresentedasa
Base64string.Themaximumdatasizeoftherequestiscontrolledbythe
maxAllowedContentLengthandmaxReceivedMessageSizevaluesintheAPI
web.config.
ImportFile Queueajobtoimportafileforadefinedimporttemplate.
IssueAssessments AssessmentscanbeinitiatedviatheAPIintofieldsonDCFtablesandon
MasterDetailrecords.Assessmentsrequirespecificdatatobeissued
appropriatelyviaaRequestXMLfile.
DeleteRecord Deletesaselectedrecordfromwithinachosencomponent.DeleteRecordwill
updatetherecord,makingitsoitwillnolongerbeviewablewithinKeylight.
Recordsaresoft-deletedtomaintainanyhistoricalreferencestotherecordand
canberestoredwithadatabasescript.
DeleteRecordAttachments Deletesthespecifiedattachmentsfromtheprovideddocumentfieldsona
specificrecord.


## RulestoKeylightAPI

TheKeylightAPIimplementsRESTfulwebservicesusing:

```
BaseURL http://[instancename]:[port]/ComponentService/GetComponent?id={ID}
HTTPverbs l GET
l POST
l DELETE
XML/JSON
Responses
```
RESTdefinesasetofarchitecturalprinciplesallowingdesignofWebservicesfocusedonthesystemresources.
ResourcesarereferencedbytheURLpathwithstandardHTTPverbstoaccessthedifferentmethods.
NoteKeylightRESTAPIisavailableonlywithKeylightEnterpriseEditionorwithanadditionallicenseinthe
KeylightStandardEdition.

**AccessConfiguration**

AllAPIrequestsaremadeusingthebaseURL.AllLoginswillbebasedonthefollowingstructure:
l http[s]://<instance_name>:<port>/SecurityService/Login
Alldatagathering/manipulationrequestswillbemadethrough
l http[s]://<instance_name>:<port>/ComponentService/<operation>
TheinstancenamedescribestheURLoftheKeylightinstallation.Theportisdeterminedbytheindividual
configurationofthesiteinstallation.
Seehttp[s]://<machine_name>:<port>/SecurityService/helpforthepublishedlistofcalltemplates.


**XML/JSON Payload**

```
Requirement Description
Permissions PermissionsfortheAPIaredeterminedbythelogoncredentialsusedtoaccessit.APIaccess
usesthepermissionsettingsforanaccountconfiguredwithintheSecurityRolessectionofthe
KeylightPlatform.UsersmustpurchaseasubscriptiontotheAPI.Formoreinformation,contact
youraccountmanager.
ThecredentialsareaccessedusingtheLoginfunctionintheSecurityServiceAPI.Thecredentials
returnacookiethatisthenpassedasauthorizationtoalloftheotherportionsoftheAPIandis
detailedintheSecurityServiceAPI.
cURL WhiletheRESTFrameworksupportsalmostanydevelopmentlanguage,examplesinthis
documentationareprovidedincURLandcanbeexecutedinastandalonecommandprompt.
cURLisatooltotransferdatafromortoaserver,usingHTTP(s)toconnecttotheKeylightweb
serviceAPIandreturnanXMLresponsethatcanbestoredandparsed.Additionalinformation
aboutcURLcanbefoundatcurl.haxx.se.Formoreinformationonkeyswitches,seecURL
Switchesintheappendix.
Data
Structure
```
```
AkeycomponentoftheKeylightarchitectureistheDynamicContentFramework(DCF)which
allowscustomerstobuildcustomized,dynamictablestostoreavarietyofdataelements.The
DCFalsoallowsforcomplexrelationalinteractionbetweencustomandpermanentKeylightdata
elements.Assuch,thecontentiscompletelycustomizedtoeachbusinessanddoesnothavea
fixedstructure.SometermswillbeusefultounderstandwhenusingtheAPItoaccesscustom
content.
Component AsingletableintheKeylightPlatform.Forexample,aRiskstable.
Field Adefinitionforasinglepieceofinformationinacomponent,for
example,theaddressofabuilding.Eachfieldisrestrictedtoauser-
defineddatatype.Formoreinformationonthefieldtypes,seeField
Typesintheappendix.
Record Acompletegroupingofmultiplefieldsforasingleidentifier.For
example,arecordmayconsistofaname,address,andphone
numberforanemployee.
```

## ThischapterincludesadescriptionofthefunctionsforlogginginandloggingoutAPIcallsandmethodsforgetting,

- KeylightAPIBasics 1:Introduction
- RulestoKeylightAPI
- SecurityServicesAPI 2:SecurityServicesAPI
- Login
- Ping
- Logout
- GetUser
- GetUsers
- GetUserCount
- CreateUser
- UpdateUser
- DeleteUser
- GetGroup
- GetGroups
- CreateGroup
- UpdateGroup
- DeleteGroup
- GetComponent 3:ComponentServicesAPI
- GetComponentList
- GetComponentByAlias
- GetFieldList
- GetAvailableLookupRecords
- GetLookupReportColumnFields
- GetRecord
- GetRecords
- GetRecordCount
- GetDetailRecord
- GetDetailRecords
- GetRecordAttachment
- GetRecordAttachments
- GetWorkflow
- GetWorkflows
- TransitionRecord
- VoteRecord
- CreateRecord
- UpdateRecord
- UpdateRecordAttachments
- ImportFile
- IssueAssessments
- DeleteRecord
- DeleteRecordAttachments
- UniqueIdentifiersforFieldTypes A: FieldTypes
- BasiccURLCommandSwitches B: cURLCommandSwitches
- GetField
- SecurityServicesAPI creating,updating,anddeletingusersandgroups.
- Login
- Ping
- Logout
- GetUser
- GetUsers
- GetUserCount
- CreateUser
- UpdateUser
- DeleteUser
- GetGroup
- GetGroups
- CreateGroup
- UpdateGroup
- DeleteGroup


## SecurityServicesAPI

SecurityServiceLoginfunctiongeneratesanencryptedcookieinthereturnheader.Thiscookiemustbecaptured
andusedasaparameterinallComponentServicecallstoverifyidentityandsetpermissions.
PermissionsforthedatathattheAPIcanaccessarebasedonpermissionsoftheLogonaccountthatisused.For
example,iftheloginaccounthasread-onlypermissionstoanassettable,theAPIreturnsdataforuserviewingbut
doesnotallowupdateordeletefunctionstobeperformed.


## Login

## Login

Acceptsanaccountusernameandpassword,verifiesthemwithinKeylightandprovidesanencryptedcookiethat
canbeusedtoauthenticateadditionalAPItransactions.

```
URL: http://[instance-name]:[port]/SecurityService/Login
Method: POST
Input: Username(Text)  UsernamefortheKeylightapplicationaccount
Password(Text) PasswordfortheKeylightapplicationaccount
Output: AcookietoestablishsessionswithinthecomponentservicesAPI.
Permissions: TheaccountthatisusedtologintotheapplicationmusthaveaccesstotheKeylightAPI.
Usersmustalsohaveappropriatepermissionsforanydatatheywishtoaccessormanipulate.
```
**Examples**
Inthisexample,cURLusesthe–coptiontostoretheencryptedcookiethatisreturnedinafile.Thecookiecanbe
senttoauthenticatealldatamanipulationcommandsintheComponentServiceAPIwithasinglecURLcommand
lineswitch(-b).Theresponsesampleincludesboththeheaderoftheresponse(toviewthecookie)andtheXML
response.

```
XML REQUEST (cURL)
curl-c cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
"<Login><username>username</username><password>password</password></Login>"
http://keylight.lockpath.com:4443/SecurityService/Login
XML RESPONSE
<booleanxmlns="http://schemas.microsoft.com/2003/10/Serialization/">true</boolean>
JSON REQUEST (cURL)
curl-c cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST
```
- d"{ \"username\": \"user1\",\"password\": \"12345\"}"
https://keylight.lockpath.com:4443/SecurityService/Login
**JSON RESPONSE**
true


**Auto-provisionanaccountusingLDAP**

IfAuto-ProvisionisenabledfortheLDAPProfileandtheauthenticateduserdoesnothaveaKeylightapplication
account,onewillbecreatedwithAPIaccessenabledandthenauthenticatedtotheKeylightapplication.

```
Input: ldapSettingsId(Int)LDAPProfileID
withinKeylightapplication
```
**Examples**

```
XML REQUEST (cURL)
curl-c cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
"<Login><username>username</username><password>password</password><ldapSettingsId>1</ldapSet
tingsId></Login>"http://keylight.lockpath.com:4443/SecurityService/Login
XML RESPONSE
<booleanxmlns="http://schemas.microsoft.com/2003/10/Serialization/">true</boolean>
JSON REQUEST (cURL)
curl-c cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST
```
- d"{ \"username\": \"user1\",\"password\": \"12345\", \"ldapSettingsId\":\"1\"}"
https://keylight.lockpath.com:4443/SecurityService/Login
**JSON RESPONSE**
true


## Ping

## Ping

RefreshesavalidKeylightPlatformsession.

```
URL: http://[instance-name]:[port]/SecurityService/Ping
Method: GET
Input: Noinputallowed 
Permissions: TheaccountthatisusedtologintotheapplicationmusthaveaccesstotheKeylightAPI.
```
**Examples**
Inthisexample,cURLusesthe-boptiontoprovideauthentication.PingusesthedefaultGETmethod,sothe
methoddoesnotneedtobespecifiedintherequest.

```
XML REQUEST (cURL)
curl-b cookie.txthttp://keylight.lockpath.com:4443/SecurityService/Ping
XML RESPONSE
<booleanxmlns="http://schemas.microsoft.com/2003/10/Serialization/">true</boolean>
JSON REQUEST (cURL)
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/SecurityService/Ping
JSON RESPONSE
true
```

## Logout

## Logout

TerminatesaKeylightPlatformsession.

```
URL: http://[instance-name]:[port]/SecurityService/Logout
Method: GET
Input: Noinputallowed 
Permissions: TheaccountthatisusedtologintotheapplicationmusthaveaccesstotheKeylightAPI.
```
**Examples**
Inthisexample,cURLusesthe-boptiontoretrieveastoredsession,authenticateit,andthenterminatethe
session.

```
XML/JSONREQUEST (cURL)
curl-b cookie.txthttp://keylight.lockpath.com:4443/SecurityService/Logout
XML/JSONRESPONSE
true
```

## GetUser

## GetUser

Returnsallfieldsforagivenuser.

```
URL: http://[instancename]:[port]/SecurityService/GetUser?id={USERID}
Method: GET
Input: ID(Integer):  TheIDofthedesireduser
Permissions: TheauthenticationaccountmusthaveReadAdministrativeAccesspermissionstoAdminister-
Users.
```
TheLanguageobjectoftheGetUsermethodrevealsthelanguageinuseintheKeylightPlatform.TheLanguage
objectworksincombinationwiththePreferredLocalefeature.Whenoneofthelanguageswithacorresponding
localecodeisactiveintheKeylightPlatform,thePreferredLocalefieldvalueinMyProfilepreferencesissetforthe
user.IntheKeylightPlatform,thedefaultlanguageisEnglish,andsinceEnglishhasarelatedlocalecode,the
defaultlanguagevalueis"1033."
IfanAPIrequestreturnsalanguagethatisnotavailable,orifalanguageisnotactiveintheinstance,theerror
message"InvalidLanguageID"returns.YoucanhoverthecursoroverthelanguagenameintheKeylightSetup>
Multilingual>LanguagesareaoftheKeylightPlatformtorevealthelanguageID.Foralistoflanguagesand
correspondinglanguageIDsavailableintheKeylightPlatform,seeLanguageIDsintheappendix.
ThefollowinglistincludesthelanguageIDsandlanguagenames,andthecorrespondinglocaleIDsandlocale
names.

```
LanguageID LanguageName LocaleID LocaleName
9 English 1033 English(UnitedStates)
9 English 2057 English(UnitedKingdom)
12 French 1036 French(France)
16 Italian 1040 Italian(Italy)
10 Spanish 2058 Spanish(Mexico)
10 Spanish 3082 Spanish(Spain)
```
**Examples**
GetUserreturnsallfieldsforagivenuser.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
"http://keylight.lockpath.com:4443/SecurityService/GetUser?id=123"
XML RESPONSE
<?xmlversion="1.0" encoding="UTF-8"?>
<UserItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
```

<Id>123</Id>
<FullName>BettyBarnes</FullName>
<Username>bettybarnes</Username>
<IsActive>true</IsActive>
<IsLocked>false</IsLocked>
<IsDeleted>false</IsDeleted>
<AccountType>1</AccountType>
<FirstName>Betty</FirstName>
<MiddleName/>
<LastName>Barnes</LastName>
<Title />
<Language>1033</Language>
<EmailAddress>betty.barnes@email.com</EmailAddress>
<HomePhone />
<WorkPhone />
<MobilePhone />
<Fax />
<IsSAML>false</IsSAML>
<IsLDAP>false</IsLDAP>
<SecurityConfiguration>
<Id>1</Id>
<DisplayName>Standard Configuration</DisplayName>
</SecurityConfiguration>
<APIAccess>false</APIAccess>
<Groups/>
<SecurityRoles>
<SecurityRole>
<Id>1</Id>
<Name>End User</Name>
</SecurityRole>
</SecurityRoles>
<FunctionalRoles />
</UserItem>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json"
"http://keylight.lockpath.com:4443/SecurityService/GetUser?id=123"


**JSON RESPONSE**
{
"Id": 123,
"FullName":"Barnes, Betty",
"Username":"bettybarnes",
"IsActive":true,
"IsLocked":false,
"IsDeleted": false,
"AccountType": 1,
"FirstName": "Betty",
"MiddleName": "",
"LastName":"Barnes",
"Title": "",
"Language":1033,
"EmailAddress":"betty.barnes@email.com",
"HomePhone": "",
"WorkPhone": "",
"MobilePhone": "",
"Fax": "",
"IsSAML": false,
"IsLDAP": false,
"SecurityConfiguration": {
"Id": 1,
"DisplayName": "StandardConfiguration"
},
"APIAccess": false,
"Groups": [],
"SecurityRoles": [
{
"Id": 1,
"Name":"EndUser"
}
],
"FunctionalRoles": []
}


## GetUsers

## GetUsers

Returnsalistofusersandsupportingfields.ThelistdoesnotincludeDeletedusersandcanincludenon-Keylight
useraccounts.

```
URL: http://[instancename]:[port]/SecurityService/GetUsers
Method: POST
Input: pageIndex(integer): Theindexofthepageofresulttoreturn.Mustbe> 0
pageSize(integer): Thesizeofthepageresultstoreturn.Mustbe>= 1
FieldFilter(optional)<Filters>: Thefilterparameterstheusersmustmeettobeincluded
```
Usefilterstoreturnonlytheusersmeetingtheselectedcriteria.Removeallfilterstoreturnalistofallusers
includingdeletednon-Keylightuseraccounts.

```
Filters: Field FilterTypes UsableValues
Active l 5 - EqualTo
l 6 - NotEqualTo
```
```
l True
l False
Deleted l 5 - EqualTo
l 6 - NotEqualTo
```
```
l True
l False
AccountType l 5 - EqualTo
l 6 - NotEqualTo
l 10002 - ContainsAny
```
```
l 1,Full,FullUser
l 2,Vendor,VendorContact,
VendorContactUser
l 4,Awareness,
AwarenessUser
Permissions: TheauthenticationaccountmusthaveReadAdministrativeAccesspermissionstoAdminister-
Users.
```

**Filter Examples**
<filters>
<FieldFilter>
<FieldPath>
<Field>
<ShortName>Deleted</ShortName>
</Field>
</FieldPath>
<FilterType>6</FilterType>
<Value>True</Value>
</FieldFilter>
<FieldFilter>
<Field>
<ShortName>Active</ShortName>
</Field>
<FilterType>5</FilterType>
<Value>False</Value>
</FieldFilter>
<FieldFilter>
<Field>
<ShortName>AccountType</ShortName>
</Field>
<FilterType>10002</FilterType>
<Value>1|4</Value>
</FieldFilter>
</filters>


**Examples**
GetUsersreturnsusersandsupportingfields.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetUsersInput.xml
"http://keylight.lockpath.com:4443/SecurityService/GetUsers"
XMLREQUEST(GetUsersInput.xml)
<GetUsers>
<pageIndex>0</pageIndex>
<pageSize>4</pageSize>
<filters>
<FieldFilter>
<Field>
<ShortName>AccountType</ShortName>
</Field>
<FilterType>10002</FilterType>
<Value>1|2</Value>
</FieldFilter>
</filters>
</GetUsers>
XML RESPONSE
<?xmlversion="1.0" encoding="UTF-8"?>
<UserListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<User>
<Id>19</Id>
<FullName>Contact1,Vendor</FullName>
<Username>vc1</Username>
<Active>true</Active>
<Deleted>false</Deleted>
<AccountType>2</AccountType>
<Vendor>
<Id>1</Id>
```

<DisplayName>Vendor1</DisplayName>
</Vendor>
</User>
<User>
<Id>10</Id>
<FullName>User,Test</FullName>
<Username>test</Username>
<Active>true</Active>
<Deleted>false</Deleted>
<AccountType>1</AccountType>
</User>
</UserList>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@GetUsersInput.json
"http://keylight.lockpath.com:4443/SecurityService/GetUsers"

**JSONREQUEST(GetUsersInput.json)**
{
"pageIndex": "0",
"pageSize":"4",
"filters":
[
{
"Field":
{
"ShortName":"AccountType"
},
"FilterType": "10002",
"Value":"1|2"
}
]
}


**JSON RESPONSE**
[
{
"Id": 19,
"FullName":"Contact1, Vendor",
"Username":"vc1",
"Active": true,
"Deleted": false,
"AccountType": 2,
"Vendor": {
"Id": 1,
"DisplayName": "Vendor1"
}
},
{
"Id": 10,
"FullName":"User, Test",
"Username":"test",
"Active": true,
"Deleted": false,
"AccountType": 1,
}
]


## GetUserCount

## GetUserCount

ReturnsacountofKeylightusers.ThecountdoesnotincludeDeletedusersandcanincludenon-Keylightuser
accounts,suchasVendorContacts.

```
URL: http://[instancename]:[port]/SecurityService/GetUserCount
Method: POST
Input: FieldFilter<Filters>: Thefilterparameterstheusersmustmeettobeincluded
```
Usefilterstoreturnonlytheusersmeetingtheselectedcriteria.Removeallfilterstoreturnacountofallusers
includingdeletednon-Keylightuseraccounts.

```
Filters: Field FilterTypes UsableValues
Active l 5 - EqualTo
l 6 - NotEqualTo
```
```
l True
l False
Deleted l 5 - EqualTo
l 6 - NotEqualTo
```
```
l True
l False
AccountType l 5 - EqualTo
l 6 - NotEqualTo
l 10002 - ContainsAny
```
```
l 1,Full,FullUser
l 2,Vendor,VendorContact,
VendorContactUser
l 4,Awareness,
AwarenessUser
Permissions: TheauthenticationaccountmusthaveReadAdministrativeAccesspermissionstoAdminister-
Users.
```

**Filter Examples**
<filters>
<FieldFilter>
<FieldPath>
<Field>
<ShortName>Deleted</ShortName>
</Field>
</FieldPath>
<FilterType>6</FilterType>
<Value>True</Value>
</FieldFilter>
<FieldFilter>
<Field>
<ShortName>Active</ShortName>
</Field>
<FilterType>5</FilterType>
<Value>False</Value>
</FieldFilter>
<FieldFilter>
<Field>
<ShortName>AccountType</ShortName>
</Field>
<FilterType>10002</FilterType>
<Value>1|4</Value>
</FieldFilter>
</filters>

**Examples**
GetUserCountreturnsacountofusers.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetUserCount.xml
"http://keylight.lockpath.com:4443/SecurityService/GetUserCount"
```

**XMLREQUEST(GetUsersCount.xml)**
<GetUserCount>
<filters>
<FieldFilter>
<Field>
<ShortName>AccountType</ShortName>
</Field>
<FilterType>5</FilterType>
<Value>1</Value>
</FieldFilter>
</filters>
</GetUserCount>

**XML RESPONSE**
<intxmlns="http://schemas.microsoft.com/2003/10/Serialization/">#</int>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@GetUserCount.json
"http://keylight.lockpath.com:4443/SecurityService/GetUserCount"

**JSONREQUEST(GetUsersCount.json)**
[
{
"Field":
{
"ShortName":"AccountType"
},
"FilterType": "5",
"Value":"1"
}
]

**JSON RESPONSE**
#


## CreateUser

## CreateUser

Createauseraccount.

```
URL: http://[instancename]:[port]/SecurityService/CreateUser
Method: POST
Input: Varioususer
fields 
Permissions: TheauthenticationaccountmusthaveReadandCreateAdministrativeAccesspermissionsto
Administer-Users.Forvendorcontacts,theauthenticationaccountmustalsohavethefollowing
permissions:
l Read,Create,UpdateGeneralAccesstoVendorProfiles
l ViewandEditVendorProfilesworkflowstage
l VendorProfilesrecordpermission
```
TheLanguageobjectoftheCreateUsermethoddeterminesthelanguageintheKeylightPlatform.TheLanguage
objectworksincombinationwiththePreferredLocalefeature.Whenoneofthelanguageswithacorresponding
localecodeisactiveintheKeylightPlatform,thePreferredLocalefieldvalueinMyProfilepreferencesissetforthe
user.IntheKeylightPlatform,thedefaultlanguageisEnglish,andsinceEnglishhasarelatedlocalecode,the
defaultlanguagevalueis"1033."
IfanAPI requestusesanavailablelanguage,butthelanguageobjectdoesnothaveacorrespondinglocalecode,
theexistinglanguagepersists,andthedefaultPreferredLocaleIDremainssetto"1033."Forexample,ifthe
existinglanguageisPortuguese,whichdoesnothavearelatedlocalecode,thelanguagepersists,andthe
PreferredLocalefieldvalueisEnglish(UnitedStates).
IfanAPIrequestcallsforalanguagethatisnotavailable,orifalanguageisnotactiveintheinstance,theerror
message"InvalidLanguageID"returns.YoucanhoverthecursoroverthelanguagenameintheKeylightSetup>
Multilingual>LanguagesareaoftheKeylightPlatformtorevealthelanguageID.Foralistoflanguagesand
correspondinglanguageIDsavailableintheKeylightPlatform,seeLanguageIDsintheappendix.
ThefollowinglistincludesthelanguageIDsandlanguagenames,andthecorrespondinglocaleIDsandlocale
names.

```
LanguageID LanguageName LocaleID LocaleName
9 English 1033 English(UnitedStates)
9 English 2057 English(UnitedKingdom)
12 French 1036 French(France)
16 Italian 1040 Italian(Italy)
10 Spanish 2058 Spanish(Mexico)
10 Spanish 3082 Spanish(Spain)
```

**Examples**
CreateUsercreatesauseraccount.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@CreateUser.xml
"http://keylight.lockpath.com:4443/SecurityService/CreateUser"
XMLREQUEST(CreateUser.xml)
<CreateUser>
<userxmlns:a='http://www.w3.org/2001/XMLSchema'>xmlns:i='http://www.w3.org/2001/XMLSchema-instance'
<Username>test</Username>
<Password>password</Password>
<Active>true</Active>
<Locked>false</Locked>
<AccountType>1</AccountType>
<FirstName>test</FirstName>
<MiddleName></MiddleName>
<LastName>user</LastName>
<Title></Title>
<Language>1033</Language>
<EmailAddress>test@user.com</EmailAddress>
<HomePhone></HomePhone>
<WorkPhone></WorkPhone>
<MobilePhone></MobilePhone>
<Fax></Fax>
<Manager>
<Id>12</Id>
</Manager>
<Department>
<Id>10</Id>
</Department>
<IsSAML>false</IsSAML>
<IsLDAP>false</IsLDAP>
```

<LDAPDirectory>
<Id>1</Id>
</LDAPDirectory>
<SecurityConfiguration>
<Id>1</Id>
</SecurityConfiguration>
<APIAccess>false</APIAccess>
<Groups>
<Group>
<Id>5</Id>
</Group>
</Groups>
<SecurityRoles>
<SecurityRole>
<Id>1</Id>
</SecurityRole>
</SecurityRoles>
<FunctionalRoles>
<Record>
<Id>9</Id>
</Record>
</FunctionalRoles>
</user>
</CreateUser>

**XMLREQUEST(VendorContact.xml)**
<CreateUser>
<user xmlns:i='http://www.w3.org/2001/XMLSchema-instance'
xmlns:a='http://www.w3.org/2001/XMLSchema'>
<Username>vendor</Username>
<AccountType>2</AccountType>
<Vendor>
<Id>1</Id>
</Vendor>


<FirstName>Vendor</FirstName>
<MiddleName></MiddleName>
<LastName>Contact</LastName>
<Title></Title>
<Language>1033</Language>
<EmailAddress>vendor@contact.com</EmailAddress>
<WorkPhone></WorkPhone>
<MobilePhone></MobilePhone>
<Fax></Fax>
<VendorComments></VendorComments>
</user>
</CreateUser>

**XML RESPONSE**
GetUser


**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@CreateUser.json
[http://keylight.lockpath.com:4443/SecurityService/CreateUser](http://keylight.lockpath.com:4443/SecurityService/CreateUser)

**JSONREQUEST(CreateUser.json)**
{
"Username":"test",
"Password":"password",
"Active": true,
"Locked": false,
"AccountType": 1,
"FirstName": "Test",
"MiddleName": "",
"LastName":"User",
"Title": "",
"Language":1033,
"EmailAddress":"test@user.com",
"HomePhone": "",
"WorkPhone": "",
"MobilePhone": "",
"Fax": "",
"IsSAML": false,
"IsLDAP": true,
"LDAPDirectory": {
"Id": "1"
},
"Manager": {
"Id": "10"
},
"Department": {
"Id": "10"
},
"SecurityConfiguration": {
"Id": "1"
},
"APIAccess": false,


"Groups": [
{
"Id": "2"
}
],
"SecurityRoles": [
{
"Id": "1"
}
],
"FunctionalRoles": [
{
"Id": "9"
}
]
}

**JSONREQUEST(VendorContact.json)**
{
"Username":"vendor",
"AccountType": 2,
"Vendor": {
"Id": "1"
},
"FirstName": "Vendor",
"MiddleName": "",
"LastName":"Contact",
"Title": "",
"Language":1033,
"EmailAddress":"vendor@contact.com",
"HomePhone": "",
"WorkPhone": "",
"MobilePhone": "",
"Fax": "",
"VendorComments": ""
}


**JSON RESPONSE**
GetUser


## UpdateUser

## UpdateUser

Updateauseraccount.

```
URL: http://[instancename]:[port]/SecurityService/UpdateUser
Method: POST
Input: Varioususerfields. 
Permissions: TheauthenticationaccountmusthaveReadandUpdateAdministrativeAccesspermissionsto
Administer-Users.Forvendorcontacts,theauthenticationaccountmustalsohavethefollowing
permissions:
l ReadandUpdateGeneralAccesstoVendorProfiles
l ViewandEditVendorProfilesworkflowstage
l VendorProfilesrecordpermission
```
TheLanguageobjectoftheUpdateUsermethoddeterminesthelanguageintheKeylightPlatform.TheLanguage
objectworksincombinationwiththePreferredLocalefeature.Whenoneofthelanguageswithacorresponding
localecodeisactiveintheKeylightPlatform,thePreferredLocalefieldvalueinMyProfilepreferencesissetforthe
user.IntheKeylightPlatform,thedefaultlanguageisEnglish,andsinceEnglishhasarelatedlocalecode,the
defaultlanguagevalueis"1033."
IfanAPI requestusesanavailablelanguage,butthelanguageobjectdoesnothaveacorrespondinglocalecode,
theexistinglanguagepersists,andthedefaultPreferredLocaleIDremainssetto"1033."Forexample,ifthe
existinglanguageisPortuguese,whichdoesnothavearelatedlocalecode,thelanguagepersists,andthe
PreferredLocalefieldvalueisEnglish(UnitedStates).
IfanAPIrequestcallsforalanguagethatisnotavailable,orifalanguageisnotactiveintheinstance,theerror
message"InvalidLanguageID"returns.YoucanhoverthecursoroverthelanguagenameintheKeylightSetup>
Multilingual>LanguagesareaoftheKeylightPlatformtorevealthelanguageID.Foralistoflanguagesand
correspondinglanguageIDsavailableintheKeylightPlatform,seeLanguageIDsintheappendix.
ThefollowinglistincludesthelanguageIDsandlanguagenames,andthecorrespondinglocaleIDsandlocale
names.

```
LanguageID LanguageName LocaleID LocaleName
9 English 1033 English(UnitedStates)
9 English 2057 English(UnitedKingdom)
12 French 1036 French(France)
16 Italian 1040 Italian(Italy)
10 Spanish 2058 Spanish(Mexico)
10 Spanish 3082 Spanish(Spain)
```

**Examples**
UpdateUserupdatesauseraccount.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@UpdateUser.xml
"http://keylight.lockpath.com:4443/SecurityService/UpdateUser"
XMLREQUEST(UpdateUser.xml)
<UpdateUser>
<userxmlns:a='http://www.w3.org/2001/XMLSchema'>xmlns:i='http://www.w3.org/2001/XMLSchema-instance'
<Id>10</Id>
<Username>test</Username>
<Password>password</Password>
<Active>true</Active>
<Locked>false</Locked>
<AccountType>1</AccountType>
<FirstName>test</FirstName>
<MiddleName></MiddleName>
<LastName>user</LastName>
<Title></Title>
<Language>1033</Language>
<EmailAddress>test@user.com</EmailAddress>
<HomePhone></HomePhone>
<WorkPhone></WorkPhone>
<MobilePhone></MobilePhone>
<Fax></Fax>
<IsSAML>false</IsSAML>
<IsLDAP>true</IsLDAP>
<LDAPDirectory>
<Id>1</Id>
</LDAPDirectory>
<Manager>
<Id>15</Id>
```

</Manager>
<Department>
<Id>601</Id>
</Department>
<SecurityConfiguration>
<Id>1</Id>
</SecurityConfiguration>
<APIAccess>true</APIAccess>
<Groups>
<Group>
<Id>2</Id>
</Group>
<Group>
<Id>3</Id>
</Group>
</Groups>
<SecurityRoles>
<SecurityRole>
<Id>1</Id>
</SecurityRole>
<SecurityRole>
<Id>2</Id>
</SecurityRole>
</SecurityRoles>
<FunctionalRoles>
<Record>
<Id>34</Id>
</Record>
<Record>
<Id>35</Id>
</Record>
</FunctionalRoles>
</user>


</UpdateUser>

**XML RESPONSE**
GetUser

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@UpdateUser.json
[http://keylight.lockpath.com:4443/SecurityService/UpdateUser](http://keylight.lockpath.com:4443/SecurityService/UpdateUser)

**JSONREQUEST(UpdateUser.json)**
{
"Id": "9504",
"Username":"test",
"Password":"password",
"Active": true,
"Locked": false,
"AccountType": 1,
"FirstName": "Test",
"MiddleName": "",
"LastName":"User",
"Title": "",
"Language":1033,
"EmailAddress":"test@user.com",
"HomePhone": "",
"WorkPhone": "",
"MobilePhone": "",
"Fax": "",
"IsSAML": false,
"IsLDAP": true,
"LDAPDirectory": {
"Id": "1"
},
"Manager": {
"Id": "15"
},
"Department": {
"Id": "601"
},


```
"SecurityConfiguration": {
"Id": "1"
},
"APIAccess": true,
"Groups": [
{
"Id": "2"
},
{
"Id": "3"
}
],
"SecurityRoles": [
{
"Id": "1"
},
{
"Id": "2"
}
],
"FunctionalRoles": [
{
"Id": "34"
},
{
"Id": "35"
}
]
}
```
]

```
JSONRESPONSE
GetUser
```

## DeleteUser

## DeleteUser

Deleteauseraccount.

```
URL: http://[instancename]:[port]/SecurityService/DeleteUser
Method: DELETE
Input: ID:  TheIDoftheuser
Permissions: TheauthenticationaccountmusthaveReadandDeleteAdministrativeAccesspermissionsto
Administer-Users.Forvendorcontacts,theauthenticationaccountcanalternativelyhaveRead
andDeleteGeneralAccesstoVendorProfiles.
```
**Examples**
DeleteUserdeletesauseraccount.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XDELETE -d
"<DeleteUser><id>10</id></DeleteUser>"
"http://keylight.lockpath.com:4443/SecurityService/DeleteUser"
XML RESPONSE
<intxmlns="http://schemas.microsoft.com/2003/10/Serialization/">true</int>
JSON REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X
DELETE-d"10"
http://keylight.lockpath.com:4443/SecurityService/DeleteUser
JSON RESPONSE
true
```

## GetGroup

## GetGroup

Returnsallfieldsforagivengroup.

```
URL: http://[instancename]:[port]/SecurityService/GetGroup
Method: GET
Input: ID:  TheIDofthedesiredgroup
Permissions: TheauthenticationaccountmusthaveReadAdministrativeAccesspermissionstoAdminister-
Groups.
```
**Examples**
GetGroupreturnsallfieldsforagivengroup.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
"http://keylight.lockpath.com:4443/SecurityService/GetGroup?id=2"
XML RESPONSE
<?xmlversion="1.0" encoding="UTF-8"?>
<GroupItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>2</Id>
<Name>test group</Name>
<Description />
<BusinessUnit>false</BusinessUnit>
<LDAPDirectory>
<Id>1</Id>
<DisplayName>whoa</DisplayName>
</LDAPDirectory>
<LDAPGroupName>0b7fb422-3609-4587-8c2e-94b10f67d1bf</LDAPGroupName>
<LDAPGroupDN>CN=whoa,DC=lockpath,DC=com</LDAPGroupDN>
<SecurityRoles />
<Users />
<ChildGroups />
<ParentGroups />
</GroupItem>
```

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json"
[http://keylight.lockpath.com:4443/SecurityService/GetGroup?id=2](http://keylight.lockpath.com:4443/SecurityService/GetGroup?id=2)

**JSON RESPONSE**
{
"Id": 2,
"Name":"0b7fb422-3609-4587-8c2e-94b10f67d1bf",
"Description": "",
"BusinessUnit":false,
"LDAPDirectory": {
"Id": 1,
"DisplayName": "whoa"
},
"LDAPGroupName": "0b7fb422-3609-4587-8c2e-94b10f67d1bf",
"LDAPGroupDN": "CN=whoa,DC=dev,DC=lockpath,DC=com",
"SecurityRoles": [],
"Users": [],
"ChildGroups": [],
"ParentGroups":[]
}


## GetGroups

## GetGroups

ReturnstheIDandNameforgroups.Afiltermaybeappliedtoreturnonlythegroupsmeetingselectedcriteria.

```
URL: http://[instancename]:[port]/SecurityService/GetGroups
Method: POST
Input: pageIndex(Integer):  Theindexofthepageofresulttoreturn.Mustbe> 0
pageSize(Integer): Thesizeofthepageresultstoreturn.Mustbe>= 1
FieldFilter(optional)<Filters>: Thefilterparametersthegroupsmustmeettobeincluded
Filter: <filters>
<FieldFilter>
<FieldPath>
<Field>
<ShortName>BusinessUnit</ShortName>
</Field>
</FieldPath>
<FilterType>5</FilterType>
<Value>False</Value>
</FieldFilter>
</filters>
Permissions: TheauthenticationaccountmusthaveReadAdministrativeAccesspermissionstoAdminister-
Groups.
```
**Examples**
GetGroupsreturnstheIDandnameforgroups.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetGroups.xml
http://keylight.lockpath.com:4443/SecurityService/GetGroups
```

**XMLREQUEST(GetGroups.xml)**
<GetGroups>
<pageIndex>0</pageIndex>
<pageSize>100</pageSize>
<filters>
<FieldFilter>
<FieldPath>
<Field>
<ShortName>BusinessUnit</ShortName>
</Field>
</FieldPath>
<FilterType>5</FilterType>
<Value>False</Value>
</FieldFilter>
</filters>
</GetGroups>

**XML RESPONSE**
<?xmlversion="1.0" encoding="UTF-8"?>
<GroupListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Group>
<Id>10</Id>
<Name>AnonymousIncidentAnalysts</Name>
</Group>
<Group>
<Id>7</Id>
<Name>Business Continuity PlanApprovers</Name>
</Group>
</GroupList>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@GetGroups.json
[http://keylight.lockpath.com:4443/SecurityService/GetGroups](http://keylight.lockpath.com:4443/SecurityService/GetGroups)


**JSONREQUEST(GetGroups.json)**
{
"pageIndex": "0",
"pageSize":"100",
"filters":
[
{
"Field":
{
"ShortName":"BusinessUnit"
},
"FilterType": "5",
"Value":"False"
}
]
}

**JSON RESPONSE**
[
{
"Id": 10,
"Name":"Anonymous IncidentAnalysts"
},
{
"Id": 7,
"Name":"Business ContinuityPlan Approvers"
}
]


## CreateGroup

## CreateGroup

Createsagroup.

```
URL: http://[instancename]:[port]/SecurityService/CreateGroup
Method: POST
Input: Variousgroupfields 
Permissions: TheauthenticationaccountmusthaveReadandCreateAdministrativeAccesspermissionsto
Administer-Groups.
```
**Examples**
CreateGroupcreatesagroup.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@CreateGroup.xml
http://keylight.lockpath.com:4443/SecurityService/CreateGroup
XMLREQUEST(CreateGroup.xml)
<CreateGroup>
<group xmlns:i='http://www.w3.org/2001/XMLSchema-instance'
xmlns:a='http://www.w3.org/2001/XMLSchema'>
<Name>test group</Name>
<Description></Description>
<BusinessUnit>false</BusinessUnit>
<Users>
<User>
<Id>10</Id>
</User>
<User>
<Id>12</Id>
</User>
</Users>
<ChildGroups>
<Group>
<Id>5</Id>
</Group>
```

</ChildGroups>
<ParentGroups>
<Group>
<Id>10</Id>
</Group>
</ParentGroups>
</group>
</CreateGroup>

**XML RESPONSE**
GetGroup

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@CreateGroup.json
[http://keylight.lockpath.com:4443/SecurityService/CreateGroup](http://keylight.lockpath.com:4443/SecurityService/CreateGroup)

**JSONREQUEST(CreateGroup.json)**
{
"Name":"test group",
"Description": "",
"BusinessUnit":false,
"Users": [
{
"Id": "10"
},
{
"Id": "12"
}
],
"ChildGroups": [
{
"Id": "5"
}
],
"ParentGroups":[


### {

"Id": "10"
}
]
}

**JSON RESPONSE**
GetGroup


## UpdateGroup

## UpdateGroup

Updatesagroup.

```
URL: http://[instancename]:[port]/SecurityService/UpdateGroup
Method: POST
Input: Variousgroupfields. 
Permissions: TheauthenticationaccountmusthaveReadandUpdateAdministrativeAccesspermissionsto
Administer-Groups.
```
**Examples**
UpdateGroupupdatesagroup.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@UpdateGroup.xml
http://keylight.lockpath.com:4443/SecurityService/UpdateGroup
XMLREQUEST(UpdateGroup.xml)
<UpdateGroup>
<group xmlns:i='http://www.w3.org/2001/XMLSchema-instance'
xmlns:a='http://www.w3.org/2001/XMLSchema'>
<Id>6</Id>
<Name>API UpdatedGroup</Name>
<Description>Here'sa description.</Description>
<BusinessUnit>false</BusinessUnit>
<Users>
<User>
<Id>10</Id>
</User>
<User>
<Id>11</Id>
</User>
</Users>
<ChildGroups>
<Group>
<Id>5</Id>
```

</Group>
<Group>
<Id>7</Id>
</Group>
</ChildGroups>
<ParentGroups>
<Group>
<Id>2</Id>
</Group>
<Group>
<Id>3</Id>
</Group>
</ParentGroups>
</group>
</UpdateGroup>

**XML RESPONSE**
GetGroup

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@UpdateGroup.json
[http://keylight.lockpath.com:4443/SecurityService/UpdateGroup](http://keylight.lockpath.com:4443/SecurityService/UpdateGroup)

**JSONREQUEST(UpdateGroup.json)**
{
"Id": "6",
"Name":"API UpdatedGroup",
"Description": "Here'sa description.",
"BusinessUnit":false,
"Users": [
{
"Id": "10"
},
{
"Id": "11"


### }

### ],

```
"ChildGroups": [
{
"Id": "5"
},
{
"Id": "7"
}
],
"ParentGroups":[
{
"Id": "2"
},
{
"Id": "3"
}
]
}
```
]

```
JSONRESPONSE
GetGroup
```

## DeleteGroup

## DeleteGroup

Deleteagroup.

```
URL: URL:http://[instancename]:[port]/SecurityService/DeleteGroup
Method: DELETE
Input: ID:  TheIDofthegroup
Permissions: TheauthenticationaccountmusthaveReadandDeleteAdministrativeAccesspermissionsto
Administer-Groups.
```
**Examples**
DeleteGroupdeletesagroup.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XDELETE -d
"<DeleteGroup><id>10</id></DeleteGroup>"
"http://keylight.lockpath.com:4443/SecurityService/DeleteGroup"
XML RESPONSE
<intxmlns="http://schemas.microsoft.com/2003/10/Serialization/">true</int>
JSON REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X
DELETE-d"10"
http://keylight.lockpath.com:4443/SecurityService/DeleteGroup
JSON RESPONSE
true
```

```
Thischapterincludesadescriptionofthevariousmethodsandcallsforposting,getting,anddeletingdatafromthe
KeylightPlatform.
GetComponent 54
GetComponentList 55
GetComponentByAlias 57
GetField 59
GetFieldList 61
GetAvailableLookupRecords 65
GetLookupReportColumnFields 68
GetRecord 70
GetRecords 73
GetRecordCount 77
GetDetailRecord 81
GetDetailRecords 86
GetRecordAttachment 92
GetRecordAttachments 94
GetWorkflow 96
GetWorkflows 104
TransitionRecord 106
VoteRecord 108
CreateRecord 110
UpdateRecord 118
UpdateRecordAttachments 130
ImportFile 137
IssueAssessments 139
DeleteRecord 148
DeleteRecordAttachments 150
```
3:ComponentServices API


## GetComponent

RetrievesacomponentspecifiedbyitsID.Acomponentisauser-defineddataobjectsuchasacustomcontent
table.ThecomponentIDmaybefoundbyusingGetComponentList.

```
URL: http://[instancename]:[port]/ComponentService/GetComponent?id={ID}
Method: GET
Input: ID(Integer):  TheIDofthedesiredcomponent
Permissions: Theauthenticationaccountmusthave:ReadGeneralAccesspermissionsforthespecific
componentenabled.
```
**Examples**
ThissampleobtainsalistofthespecifiedcomponentwithinKeylight.GetComponentusesthedefaultGET
method,sothemethoddoesnotneedtobespecifiedintherequest.ThecURL-boptionisusedtoprovide
authentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
http://keylight.lockpath.com:4443/ComponentService/GetComponent?id=10005
XML RESPONSE
<?xmlversion="1.0"?>
<ComponentItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>10500</Id>
<Name>Incident Reports</Name>
<SystemName>LPIncidentReports</SystemName>
<ShortName>LPIncidentReports</ShortName>
</ComponentItem>
JSON REQUEST (cURL)
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/ComponentService/GetComponent?id=10005
JSON RESPONSE
{
"Id": 10050,
"Name":"Incident Reports",
"SystemName": "LPIncidentReports",
"ShortName": "LPIncidentReports"
}
```

## GetComponentList

ReturnsacompletelistofallKeylightcomponentsavailabletotheuserbasedonaccountpermissions.Noinput
elementsareused.Thelistwillbeorderedinascendingalphabeticalorderofthecomponentname.

```
URL: http://[instancename]:[port]/ComponentService/GetComponentList
Method: GET
Input: Noinputsallowed
Permissions: Theauthenticationaccountmusthave:ReadGeneralAccesspermissiontotheenabled
components.
```
**Examples**
ThissampleobtainsalistofallcomponentswithintheKeylightPlatform.The-boptionisusedtoprovide
authentication.GetComponentListusesthedefaultGETmethod,sothemethoddoesnotneedtobespecifiedin
therequest.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
http://keylight.lockpath.com:4443/ComponentService/GetComponentList
XML RESPONSE
<?xmlversion="1.0"?>
<ComponentListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Component>
<Id>10003</Id>
<Name>DeviceTypes</Name>
<SystemName>DeviceTypes</SystemName>
<ShortName>DeviceTypes</ShortName>
</Component>
<Component>
<Id>10001</Id>
<Name>Devices</Name>
<SystemName>Devices</SystemName>
<ShortName>Devices</ShortName>
</Component>
...
</ComponentList>
```

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/ComponentService/GetComponentList

**JSON RESPONSE**
[
{
"Id":"10003",
"Name":"DeviceTypes",
"SystemName":"DeviceTypes",
"ShortName":"DeviceTypes"
},
{
"Id":"10001",
"Name":"Devices",
"SystemName":"Devices",
"ShortName":"Devices"
}
]


## GetComponentByAlias

RetrievesacomponentspecifiedbyitsAlias.Acomponentisauser-defineddataobjectsuchasacustomcontent
table.ThecomponentAliasmaybefoundbyusingGetComponentList(ShortName).

```
URL: http://[instancename]:[port]/ComponentService/GetComponentByAlias?alias={Alias}
Method: GET
Input: Alias(String):  TheAliasofthedesiredcomponent
Permissions: Theauthenticationaccountmusthave:ReadGeneralAccesspermissionforthespecific
componentenabled.
```
**Examples**
ThissampleobtainsalistofthespecifiedcomponentwithintheKeylightPlatform.GetComponentByAliasusesthe
defaultGETmethod,sothemethoddoesnotneedtobespecifiedintherequest.ThecURL-boptionisusedto
provideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
http://keylight.lockpath.com:4443/ComponentService/GetComponentByAlias?alias=IncidentReports
XML RESPONSE
<?xmlversion="1.0"?>
<ComponentItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>10021</Id>
<Name>Incident Reports</Name>
<SystemName>IncidentReports</SystemName>
<ShortName>IncidentReports</ShortName>
</ComponentItem>
```

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/ComponentService/GetComponentByAlias?alias=IncidentReport
s

**JSON RESPONSE**
{
"Id": 10050,
"Name":"Incident Reports",
"SystemName": "LPIncidentReports",
"ShortName": "LPIncidentReports"
}


## GetField

RetrievesdetailsforafieldspecifiedbyitsID.ThefieldIDmaybefoundbyusingGetField.

```
URL: http://[instancename]:[port]/ComponentService/GetField?id={FieldId}
Method: GET
Input: ID(Integer):  ThefieldIDfortheindividualfieldwithinthecomponent
FieldTypes: Theresponseincludesanintegervalueforfieldtype.Thefieldsaretranslatedasdescribed:
FieldTypes
ID Type ID Type ID Type
1 Text 5 Lookup 9 Assessments
2 Numeric 6 Master/Detail 10 Yes/No
3 Date 7 Matrix
4 IP Address 8 Documents
Permissions: Theauthenticationaccountmusthave:ReadGeneralAccesspermissiontotheenabled
componentandfield.
```
**Examples**
ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
http://keylight.lockpath.com:4443/ComponentService/GetField?id=12
```

**XML RESPONSE**
<?xmlversion="1.0"?>
<FieldItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>12</Id>
<Name>Subnet Mask</Name>
<SystemNamei:nil="true"/>
<ShortName>SubnetMask</ShortName>
<ReadOnly>false</ReadOnly>
<Required>false</Required>
<Nullable>false</Nullable>
<FieldType>4</FieldType>
<MaxLength i:nil="true"/>
<Precision i:nil="true"/>
<Scale i:nil="true"/>
<OneToMany>false</OneToMany>
</FieldItem>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/ComponentService/GetField?Id=12

**JSON RESPONSE**
{
"Id": 12,
"Name":"SubnetMask",
"SystemName": "SubnetMask",
"ShortName": "SubnetMask",
"ReadOnly":false,
"Required":false,
"FieldType": 4,
"OneToMany": false,
"MatrixRows": []
}


## GetFieldList

RetrievesdetailfieldlistingforacomponentspecifiedbyitsID.ThecomponentIDmaybefoundbyusing
GetComponentList.Assessmentsfieldtypewillnotbevisibleinthislist.

```
URL: http://[instancename]:[port]/ComponentService/GetFieldList?componentId={COMPONENTID}
Method: GET
Input: componentId(Integer):  TheIDofthedesiredcomponent
Permissions: Theauthenticationaccountmusthave:ReadGeneralAccesspermissiontotheselected
component.
Fieldstowhichtheaccountdoesnothaveaccessarenotreturned.
```
**Examples**
ThecURL-boptionisusedtoprovideauthentication.GetFieldListusesthedefaultGETmethod,sothemethod
doesnotneedtobespecifiedintherequest.

```
XML REQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
http://keylight.lockpath.com:4443/ComponentService/GetFieldList?componentId=10001
XML RESPONSE
<FieldListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Field>
<Id>9</Id>
<Name>AcquisitionCost</Name>
<SystemNamei:nil="true"/>
<ShortName>Cost</ShortName>
<ReadOnly>false</ReadOnly>
<Required>false</Required>
<Nullable>false</Nullable>
<FieldType>2</FieldType>
<MaxLength i:nil="true"/>
<Precision>15</Precision>
<Scale>2</Scale>
<OneToMany>false</OneToMany>
</Field>
```

<Field>
<Id>10</Id>
<Name>AcquisitionDate</Name>
<SystemNamei:nil="true"/>
<ShortName>AcquisitionDate</ShortName>
<ReadOnly>false</ReadOnly>
<Required>false</Required>
<Nullable>false</Nullable>
<FieldType>3</FieldType>
<MaxLength i:nil="true"/>
<Precision i:nil="true"/>
<Scale i:nil="true"/>
<OneToMany>false</OneToMany>
</Field>
<Field>
<Id>6</Id>
<Name>AssetTag</Name>
<SystemNamei:nil="true"/>
<ShortName>AssetTag</ShortName>
<ReadOnly>false</ReadOnly>
<Required>false</Required>
<Nullable>false</Nullable>
<FieldType>1</FieldType>
<MaxLength>100</MaxLength>
<Precision i:nil="true"/>
<Scale i:nil="true"/>
<OneToMany>false</OneToMany>
</Field>


<Field>
<Id>11</Id>
<Name>IPAddress</Name>
<SystemName>IPAddress</SystemName>
<ShortName>IPAddress</ShortName>
<ReadOnly>false</ReadOnly>
<Required>false</Required>
<Nullable>false</Nullable>
<FieldType>4</FieldType>
<MaxLength i:nil="true"/>
<Precision i:nil="true"/>
<Scale i:nil="true"/>
<OneToMany>false</OneToMany>
</Field>
</FieldList>

**JSON REQUEST(cURL)**
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/ComponentService/GetFieldList?componentId=10001

**JSON RESPONSE**
[
{
"Id": 9,
"Name":"AcquisitionCost",
"SystemName": "Cost",
"ShortName":"Cost",
"ReadOnly":false,
"Required":false,
"FieldType":2,
"Precision":15,
"Scale":2,
"OneToMany":false,
"MatrixRows": []
},
{
"Id": 10,


"Name":"AcquisitionDate",
"SystemName": "AcquisitionDate",
"ShortName":"AcquisitionDate",
"ReadOnly":false,
"Required":false,
"FieldType":3,
"OneToMany":false,
"MatrixRows": []
},
{
"Id": 6,
"Name":"Asset Tag",
"SystemName": "AssetTag",
"ShortName":"AssetTag",
"ReadOnly":false,
"Required":false,
"FieldType":1,
"MaxLength":100,
"OneToMany":false,
"MatrixRows": []
},
{
"Id": 11,
"Name":"IPAddress",
"SystemName": "IPAddress",
"ShortName":"IPAddress",
"ReadOnly":false,
"Required":false,
"FieldType":4,
"OneToMany":false,
"MatrixRows": []
}
]


## GetAvailableLookupRecords

Retrievesrecordsthatareavailableforpopulationforalookupfield.

```
URL: http://[instance-name]:[port]/ComponentService/GetAvailableLookupRecords
Method: POST
Input: fieldId(integer):  TheIDofthedesiredcomponent
pageIndex(integer): Theindexofthepageofresulttoreturn.Mustbe> 0
pageSize(integer): Thesizeofthepageresultstoreturn.Mustbe>= 1
recordId(integer): OptionalIDoftherecordforwhichretrievinglookuprecords
Permissions: TheauthenticationaccountmusthaveRead/Createaccesstothecomponentthatcontainsthe
lookupfieldifnorecordIdissupplied,Read/Editaccesstothecomponentthatcontainsthelookup
fieldifarecordIdissupplied,Read/Editaccesstothelookupfield,ReadaccesstotherecordId,
andReadaccesstoanylookuprecords.
```
**Examples**
The-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetAvailableLookupRecords.xml
http://keylight.lockpath.com:4443/ComponentService/GetAvailableLookupRecords
XMLREQUEST(GetAvailableLookupRecords.xml)
<GetAvailableLookupRecords>
<fieldId>12345</fieldId>
<pageIndex>0</pageIndex>
<pageSize>1000</pageSize>
<recordId>123</recordId>
</GetAvailableLookupRecords>
```

**XMLRESPONSE**
<returns>
<ArrayOfDynamicRecordItem xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<DynamicRecordItem>
<Id>1</Id>
<DisplayName>TheFirst Record</DisplayName>
<FieldValues/>
</DynamicRecordItem>
<DynamicRecordItem>
<Id>2</Id>
<DisplayName>TheSecond Record</DisplayName>
<FieldValues/>
</DynamicRecordItem>
<DynamicRecordItem>
<Id>3</Id>
<DisplayName>TheThird Record</DisplayName>
<FieldValues/>
</DynamicRecordItem>
</ArrayOfDynamicRecordItem>
</returns>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@GetAvailableLookupRecords.json
[http://keylight.lockpath.com:4443/ComponentService/GetAvailableLookupRecords](http://keylight.lockpath.com:4443/ComponentService/GetAvailableLookupRecords)

**JSONREQUEST(GetAvailableLookupRecords.json)**
{
"fieldId": "12345",
"pageIndex": "0",
"pageSize":"1000",
"recordId":"123"
}


**JSONRESPONSE**
[
{
"Id":1,
"DisplayName": "TheFirstRecord",
"FieldValues": []
},
{
"Id":2,
"DisplayName": "TheSecond Record",
"FieldValues": []
},
{
"Id":3,
"DisplayName": "TheThirdRecord",
"FieldValues": []
}
]


## GetLookupReportColumnFields

Getsthefieldinformationofeachfieldinafieldpaththatcorrespondstoalookupreportcolumn.ThelookupFieldId
correspondstoalookupfieldwithareportdefinitiononitandthefieldPathIdcorrespondstothefieldpathtoretrieve
fieldsfrom,whichisobtainedfromGetDetailRecord.GetLookupReportColumnFieldscompliments
GetRecordDetailbyaddingadditionaldetailsaboutthelookupreportcolumnsreturnedfromGetRecordDetail.

```
URL: "http://[instancename]:[port]/ComponentService/GetLookupReportColumnFields?lookupFieldId=
{FIELDID}&fieldPathId={FIELDPATHID}"
Method: GET
Input: lookupFieldId(Integer):  TheIDofthedesiredlookupfield
fieldPathId(Integer): TheIDforthedesiredlookupfieldpath
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
"http://keylight.lockpath.com:4443/ComponentService/GetLookupReportColumnFields?lookupFieldI
d=1234&fieldPathId=5678"
XML RESPONSE
<LookupReportFieldListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Field>
<Id>123</Id>
<ComponentId>111</ComponentId>
<Name>Workflow Stage</Name>
<SystemName>WorkflowStage</SystemName>
</Field>
</LookupReportFieldList>
```

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/ComponentService/GetLookupReportColumnFields?lookupFieldI
d=1234&fieldPathId=5678"

**JSON RESPONSE**
[
{
"Id": 3,
"ComponentId": 10001,
"Name":"DNSName",
"SystemName": "DNSName"
}
]


## GetRecord

Returnsthecompletesetoffieldsforagivenrecordwithinacomponent.

```
URL: http://[instancename]:[port]/ComponentService/GetRecord?componentId=
{COMPONENTID}&recordId={RECORDID}
Method: GET
Input: componentID(Integer):  TheIDofthedesiredcomponent
recordId(Integer): TheIDfortheindividualrecordwithinthecomponent
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**
TheGetRecordretrievesallfieldswithpermissiontoforagivenrecord.Thefieldkeyscanbematchedwiththedata
fromtheGetFieldmethodtogetthenameofthefield.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
"http://keylight.lockpath.com:4443/ComponentService/GetRecord?componentId=10001&recordId=1"
XML RESPONSE
<DynamicRecordItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>1</Id>
<DisplayName>192.168.1.84</DisplayName>
<FieldValues>
<KeyValuePair>
<key>10</key>
<valuei:nil="true"/>
</KeyValuePair>
<KeyValuePair>
<key>1628</key>
<valuei:type="DynamicRecordList"/>
</KeyValuePair>
```

<KeyValuePair>
<key>6</key>
<valuei:type="a:string"
xmlns:a="http://www.w3.org/2001/XMLSchema"/></KeyValuePair><KeyValuePair><k
ey>34</key><valuei:type="DynamicRecordList"/>
</KeyValuePair>
<KeyValuePair>
<key>2203</key>
<valuei:type="DynamicRecordList"/>
</KeyValuePair>
<KeyValuePair>
<key>9</key>
<valuei:nil="true"/>
</KeyValuePair>
<KeyValuePair>
<key>301</key>
<valuei:type="a:dateTime"xmlns:a="http://www.w3.org/2001/XMLSchema">2012-
10-22T08:45:25.157</value>
</KeyValuePair>
<KeyValuePair>
<key>303</key>
<valuei:type="DynamicRecordItem">
<Id>0</Id>
<DisplayName>System,Keylight</DisplayName>
<FieldValues/>
</value>
</KeyValuePair>
<KeyValuePair>
<key>15</key>
<valuei:type="a:string" xmlns:a="http://www.w3.org/2001/XMLSchema"/>
</KeyValuePair>
...
<KeyValuePair>
<key>351</key>
<valuei:type="DynamicRecordItem">
<Id>5</Id>
<DisplayName>Published</DisplayName>
<FieldValues/>
</value>


</KeyValuePair>
</FieldValues>
</DynamicRecordItem>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
"https://keylight.lockpath.com:4443/ComponentService/GetRecord?componentId=10001&recordId=1"

**JSON RESPONSE**
{
"Id": 1,
"DisplayName": "192.168.1.84",
"FieldValues": [
{
"Key": 3852,
"Value": 1
},
{
"Key": 3853,
"Value": 8
},
{
"Key": 3858,
"Value":{
"__type": "DynamicRecordItem",
"Id": 0,
"DisplayName": "System,Keylight",
"FieldValues": []
}
},
{
"Key": 3860,
"Value":false
}
}


## GetRecords

Returnthetitle/defaultfieldforasetofrecordswithinachosencomponent.Filtersmaybeappliedtoreturnonlythe
recordsmeetingselectedcriteria.

```
URL: http://[instancename]:[port]/ComponentService/GetRecords
Method: POST
Input: componentID(Integer): TheIDofthedesiredcomponent
pageIndex(Integer): Theindexofthepageofresulttoreturn.Mustbe> 0
pageSize(Integer): Thesizeofthepageresultstoreturn.Mustbe>= 1
SearchCriteriaItem(optional)<Filters>: Thefilterparameterstherecordsmustmeettobe
counted
Filters: <filters>
<SearchCriteriaItem>
<FieldPath>
<int>7</int>
</FieldPath>
<FilterType>ID</FilterType>
<Value>value</Value>
</SearchCriteriaItem>
</filters>
SearchCriteriaItem: Describesasinglefilter.GetRecordCountsupports
addinganinfiniteamountoffiltercriteria.
FieldPath: DescribesthefieldIDforthecolumnthatthe
recordswillbefilteredon.Ifthevalueisstoredin
thecomponentdirectly,onlyoneFieldPathvariable
isneeded.However,ifthevalueisalookupto
anothercomponent,anadditionalFieldPath
variablewillberequiredwiththecolumnvalue
wherethedataresides.FieldPathvariablescanbe
addedasmanyasnecessarytoprovidethecorrect
pathtothedata.
FilterType: DescribestheIDforthefilterbeingimplemented.
Forexample,theFilterTypeforIsNullwouldbe15.
IftheFilterTypewouldexcludetheentryofavalue
likeIsEmpty(13)orIsNotNull(16),the<Value>
tagsshouldberemovedfromtherequest.
FilterTypesarelistedinthefollowingtable:
```

```
FilterTypes
ID Filter ID Filter ID Filter
1 Contains 8 < 15 IsNull
2 Excludes 9 >= 16 IsNot
Null
3 Starts
With
```
```
10 <= 10001 Offset
```
```
4 Ends
With
```
```
11 Between 10002 Contains
Any
5 = 12 Not
Between
```
```
10003 Contains
Only
6 <> 13 IsEmpty 10004 Contains
None
7 > 14 IsNot
Empty
```
10005 Contains
AtLeast
Value: Matchesvalue(ifapplicable).Forexample,ifthe
filterisStartsWith"st,"theValuewouldbe
<Value>st</Value>.
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
DescribestheIDforthefilterbeingimplemented.Forexample,theFilterTypeforIsNullwouldbe
15.IftheFilterTypewouldexcludetheentryofavaluelikeIsEmpty(13)orIsNotNull(16),the
<Value>tagsshouldberemovedfromtherequest.FilterTypesarelistedinthetablebelow.


**Examples**

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetRecordsInput.xmlhttp://keylight.lockpath.com:4443/ComponentService/GetRecords
XML REQUEST (GetRecordsInput.xml)
<GetRecords>
<componentId>10001</componentId>
<pageIndex>0</pageIndex>
<pageSize>2</pageSize>
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>11</int>
</FieldPath>
<FilterType>16</FilterType>
<Value></Value>
</SearchCriteriaItem>
</filters>
</GetRecords>
XML RESPONSE
<ArrayOfDynamicRecordItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<DynamicRecordItem>
<Id>1</Id>
<DisplayName>192.168.1.84</DisplayName>
<FieldValues/>
</DynamicRecordItem>
<DynamicRecordItem>
<Id>2</Id>
<DisplayName>192.168.1.69</DisplayName>
<FieldValues/>
</DynamicRecordItem>
</ArrayOfDynamicRecordItem>
```

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@GetRecordsInput.json
[http://keylight.lockpath.com:4443/ComponentService/GetRecordCount](http://keylight.lockpath.com:4443/ComponentService/GetRecordCount)

**JSONREQUEST(GetRecordCount.json)**
{
"componentId": "10001",
"pageIndex": "0",
"pageSize":"5",
"filters": [
{
"FieldPath":[
11
],
"FilterType": "1",
"Value":"text value"
}
]
}

**JSONRESPONSE**
[
{
"Id": 1,
"DisplayName": "192.168.1.84",
"FieldValues": []
},
{
"Id": 2,
"DisplayName": "192.168.1.69",
"FieldValues": []
},
]


## GetRecordCount

Returnthenumberofrecordsinagivencomponent.Filtersmaybeappliedtoreturnthecountofrecordsmeetinga
givencriteria.Thisfunctionmaybeusedtohelpdeterminetheamountofrecordsbeforeretrievingtherecords
themselves.

```
URL: http://[instancename]:[port]/ComponentService/GetRecordCount
Method: POST
Input: componentID(Integer): TheIDofthedesiredcomponent
SearchCriteriaItem(optional)<Filters>: Thefilterparameterstherecordsmustmeettobe
counted
Filters: <filters>
<SearchCriteriaItem>
<Field Path>
<int>7</int>
</FieldPath>
<FilterType>ID</FilterType>
<Value>value</Value>
</SearchCriteriaItem>
</filters>
SearchCriteriaItem: Describesasinglefilter.GetRecordCountsupports
addinganinfiniteamountoffiltercriteria.
FieldPath: DescribesthefieldIDforthecolumnthatthe
recordswillbefilteredon.Ifthevalueisstoredin
thecomponentdirectly,onlyoneFieldPathvariable
isneeded.However,ifthevalueisalookupto
anothercomponent,anadditionalFieldPath
variablewillberequiredwiththecolumnvalue
wherethedataresides.FieldPathvariablescanbe
addedasmanyasnecessarytoprovidethecorrect
pathtothedata.
FilterType: DescribestheIDforthefilterbeingimplemented.
Forexample,theFilterTypeforIsNullwouldbe15.
IftheFilterTypewouldexcludetheentryofavalue
likeIsEmpty(13)orIsNotNull(16),the<Value>
tagsshouldberemovedfromtherequest.
FilterTypesarelistedinthefollowingtable:
```

```
FilterTypes
ID Filter ID Filter ID Filter
1 Contains 8 < 15 IsNull
2 Excludes 9 >= 16 IsNot
Null
3 Starts
With
```
```
10 <= 10001 Offset
```
```
4 Ends
With
```
```
11 Between 10002 Contains
Any
5 = 12 Not
Between
```
```
10003 Contains
Only
6 <> 13 IsEmpty 10004 Contains
None
7 > 14 IsNot
Empty
```
```
10005 Contains
AtLeast
Value: Matchesvalue(ifapplicable).Forexample,ifthe
filterisStartsWith"st,"theValuewouldbe
<Value>st</Value>.
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionto:
l Selectedcomponent
l Applicablerecords
l Applicablerecordsinthecomponent(table)
```
Formoreinformationonfilterimplementation,seeSearchFiltersintheappendix.


**Examples**
ThecURL-boptionisusedtoprovideauthentication.Inthisexample,thesearchislookingforvaluesthatdonot
haveanemptyaddressfield.Becauseofthis,thevalueparameterisleftblankbecauseIsNotEmptyisnot
comparingtoanysetvalue.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetRecordCount.xml
http://keylight.lockpath.com:4443/ComponentService/GetRecordCount
XML REQUEST(GetRecordCount.xml)
<GetRecordCount>
<componentId>10001</componentId>
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>11</int>
</FieldPath>
<FilterType>16</FilterType>
</SearchCriteriaItem>
</filters>
</GetRecordCount>
XML RESPONSE
<intxmlns="http://schemas.microsoft.com/2003/10/Serialization/">#</int>
JSON REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST
```
- d@GetRecordCount.json
[http://keylight.lockpath.com:4443/ComponentService/GetRecordCount](http://keylight.lockpath.com:4443/ComponentService/GetRecordCount)


**JSONREQUEST(GetRecordCount.json)**
{
"componentId": "10001",
"filters": [
{
"FieldPath":[
11
],
"FilterType": "1",
"Value":"text value"
}
]
}

**JSON RESPONSE**
#


## GetDetailRecord

RetrievesrecordinformationbasedontheprovidedcomponentIDandrecordID,withlookupfieldreportdetails.
Lookupfieldrecordswilldetailinformationforfieldsontheirreportdefinition,ifoneisdefined.Usingtheoptional
booleanparameter"embedRichTextImages"youcanextractimagescontainedinrichtextfields.

```
URL: "http://[instancename]:[port]/ComponentService/GetDetailRecord?componentId=
{COMPONENTID}&recordId={RECORDID}&embedRichTextImages=true"
Method: GET
Input: componentID(Integer):  TheIDofthedesiredcomponent
recordId(Integer): TheIDfortheindividualrecordwithinthecomponent
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
"http://keylight.lockpath.com:4443/ComponentService/GetDetailRecord?componentId=12345&record
Id=1&embedRichTextImages=true"
XML RESPONSE
<DynamicRecordItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>1</Id>
<DisplayName>TheFirstRecord</DisplayName>
<FieldValues>
<KeyValuePair>
<key>1234</key>
<valuei:type="a:string" xmlns:a="http://www.w3.org/2001/XMLSchema">Text
FieldContent</value>
</KeyValuePair>
```

<KeyValuePair>
<key>1235</key>
<value i:type="DynamicRecordList">
<Record>
<Id>1</Id>
<DisplayName>LookupRecord 1</DisplayName>
<FieldValues/>
<LookupReportColumns>
<Column>
<FieldPathId>2345</FieldPathId>
<ColumnName>Title</ColumnName>
<Value>LookupRecord 1</Value>
</Column>
<Column>
<FieldPathId>2346</FieldPathId>
<ColumnName>WorkflowStage: Workflow:
Name</ColumnName>
<Value>Default Workflow</Value>
</Column>
</LookupReportColumns>
</Record>


<Record>
<Id>2</Id>
<DisplayName>LookupRecord 2</DisplayName>
<FieldValues/>
<LookupReportColumns>
<Column>
<FieldPathId>2347</FieldPathId>
<ColumnName>Title</ColumnName>
<Value>Lookup Record 2</Value>
</Column>
<Column>
<FieldPathId>2348</FieldPathId>
<ColumnName>Workflow Stage:Workflow:
Name</ColumnName>
<Value>Default Workflow</Value>
</Column>
</LookupReportColumns>
</Record>
</value>
</KeyValuePair>
</FieldValues>
</DynamicRecordItem>


**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
https://keylight.lockpath.com:4443/ComponentService/GetDetailRecord?componentId=10001&record
Id=1&embedRichTextImages=true"

**JSON RESPONSE**
{
"Id": 1,
"DisplayName": "192.168.1.84",
"FieldValues": [
{
"Key": 3852,
"Value": 1
},
{
"Key": 3853,
"Value": 8
},
{
"Key": 4982,
"Value":{
"__type": "DynamicRecordItem",
"Id": 219,
"DisplayName": "192.168.30.22",
"FieldValues": [],
"LookupReportColumns": [
{
"FieldPathId": 650,
"ColumnName": "DNSName",
"Value":"machine1.test.com"
},
{
"FieldPathId": 651,
"ColumnName": "MACAddress",


"Value":"11:70:5B:91:63:35"
},
{
"FieldPathId": 649,
"ColumnName": "IPAddress",
"Value":"192.168.30.22"
}
]
}
},
{
"Key": 4983,
"Value":false
}
}


## GetDetailRecords

GetDetailRecordsprovidestheabilitytorunasearchwithfiltersandpaging(GetRecords)whilereturningahigh
levelofdetailforeachrecord(GetRecord).GetDetailRecordsalsoallowsmultiplesortstomodifytheorderofthe
results.Forperformanceandsecurityconcerns,themaximumnumberofrecordsreturned(pageSize)is1000.

```
URL: http://[instancename]:[port]/ComponentService/GetDetailRecords
Method: POST
Input: componentID(Integer):  TheIDofthedesiredcomponent
pageIndex(Integer): Theindexofthepageofresulttoreturn.Mustbe>= 0
pageSize(Integer): Thesizeofthepageresultstoreturn.Mustbe>= 1
fieldIds(optional)(Integer): TheIDofthefieldtobereturned.Ifnotprovided,returnsall
accessiblefields.Ifprovided,butempty,returnscoresystem
fields(CreatedAt,CreatedBy,etc.).Ifprovided,returnscore
systemfieldsplusaccessiblefields.Notethatsystemfieldswill
alwaysbereturnedregardless.
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetDetailRecords.xmlhttp://keylight.lockpath.com:4443/ComponentService/GetDetailRecords
XMLREQUEST(GetDetailRecords.xml)
<GetDetailRecords>
<componentId>12345</componentId>
<pageIndex>0</pageIndex>
<pageSize>2</pageSize>
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>1234</int>
</FieldPath>
<FilterType>7</FilterType>
<Value>10</Value>
```

</SearchCriteriaItem>
</filters>
<sortOrder>
<SortCriteriaItem>
<FieldPath>
<int>2345</int>
</FieldPath>
<Ascending>false</Ascending>
</SortCriteriaItem>
<SortCriteriaItem>
<FieldPath>
<int>6789</int>
</FieldPath>
<Ascending>true</Ascending>
</SortCriteriaItem>
</sortOrder>
<fieldIds>
<int>1234</int>
<int>5678</int>
</fieldIds>
</GetDetailRecords>

**XML RESPONSE**
<ArrayOfDynamicRecordItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<DynamicRecordItem xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>1</Id>
<DisplayName>The FirstRecord</DisplayName>
<FieldValues>
<KeyValuePair>
<key>1234</key>
<value i:type="a:string"
xmlns:a="http://www.w3.org/2001/XMLSchema">TextField
Content</value>
</KeyValuePair>
<KeyValuePair>
<key>1235</key>
<valuei:type="DynamicRecordList">
<Record>
<Id>1</Id>


<DisplayName>LookupRecord1</DisplayName>
<FieldValues/>
</Record>
<Record>
<Id>2</Id>
<DisplayName>LookupRecord2</DisplayName>
<FieldValues/>
</Record>
</value>
</KeyValuePair>
</FieldValues>
</DynamicRecordItem>
<DynamicRecordItem xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>2</Id>
<DisplayName>The SecondRecord</DisplayName>
<FieldValues>
<KeyValuePair>
<key>1234</key>
<value i:type="a:string"
xmlns:a="http://www.w3.org/2001/XMLSchema">TextField
Content</value>
</KeyValuePair>
<KeyValuePair>
<key>1235</key>
<value i:type="DynamicRecordList">
<Record>
<Id>3</Id>
<DisplayName>LookupRecord 3</DisplayName>
<FieldValues/>
</Record>
<Record>
<Id>4</Id>
<DisplayName>LookupRecord 4</DisplayName>
<FieldValues/>
</Record>
</value>
</KeyValuePair>
</FieldValues>
</DynamicRecordItem>


</ArrayOfDynamicRecordItem>

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@GetDetailRecords.json
[http://keylight.lockpath.com:4443/ComponentService/GetDetailRecords](http://keylight.lockpath.com:4443/ComponentService/GetDetailRecords)

**JSONREQUEST(GetDetailRecords.json)**
{
"componentId": "10001",
"pageIndex": "0",
"pageSize":"1000",
"filters": [
{
"FieldPath":[
3881
],
"FilterType": "3",
"Value":"Blue"
}
],
"sortOrder": [
{
"FieldPath":[
4991
],
"Ascending":"true"
}
],
"fieldIds":[2500,2502]
}


**JSONRESPONSE**
[
{
"Id": 1,
"DisplayName": "Record1",
"FieldValues": [
{
"Key": 2500,
"Value": 4
},
{
"Key": 2502,
"Value":{
"__type": "DynamicRecordItem",
"Id": 10,
"DisplayName": "Admin,User",
"FieldValues": []
}
}
]
},
{
"Id": 2,
"DisplayName": "Record2",
"FieldValues": [
{
"Key": 2500,
"Value": 7
},
{
"Key": 2502,
"Value":{
"__type": "DynamicRecordItem",


"Id": 11,
"DisplayName": "End,User",
"FieldValues": []
}
}
]
}
]


## GetRecordAttachment

GetsasingleattachmentassociatedwiththeprovidedcomponentID,recordID,documentsfieldID,anddocument
ID.ThefilecontentsarereturnedasaBase64string.

```
URL: "http://[instancename]:[port]/ComponentService/GetRecordAttachment?componentId=
{COMPONENTID}&recordId={RECORDID}&fieldId={FIELDID}&documentId={DOCUMENTID}"
Method: GET
Input: componentID(Integer): TheIDofthedesiredcomponent
recordId(Integer): TheIDfortheindividualrecordwithinthecomponent
fieldId(Integer): TheIDfortheindividualfieldwithinthecomponent
documentId(Integer): TheIDfortheindividualdocumentwithinthecomponent
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**
TheGetRecordAttachmentretrievesasingleattachmentforagivenfieldonarecord.GetRecordAttachmentuses
thedefaultGETmethod,sothemethoddoesnotneedtobespecifiedintherequest.ThecURL-boptionisusedto
provideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
"http://keylight.lockpath.com:4443/ComponentService/GetRecordAttachment?componentId=12345&re
cordId=1&fieldId=1234&documentId=1"
XML RESPONSE
<RecordAttachmentItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<FileName>Attachment1.txt</FileName>
<FileData>Q2hyb25vIGNhbXBhaWduDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQpQbGF5ZXJ
zOg0KLSBSZXB0aXRlIFNvc=</FileData>
</RecordAttachmentItem>
```

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
"http://keylight.lockpath.com:4443/ComponentService/GetRecordAttachment?componentId=12345&re
cordId=1&fieldId=1234&documentId=1"

**JSON RESPONSE**
{
"FileName":"Attachment1.txt",
"FileData":
"Q2hyb25vIGNhbXBhaWduDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQpQbGF5ZXJ\nzOg0KLS
BSZXB0aXRlIFNvc="
}


## GetRecordAttachments

GetsinformationforallattachmentsassociatedwiththeprovidedcomponentID,recordID,andDocumentsfieldid.
Nofiledataisreturned,onlyfilename,fieldID,anddocumentIDinformation.

```
URL: "http://[instancename]:[port]/ComponentService/GetRecordAttachments?componentId=
{COMPONENTID}&recordId={RECORDID}&fieldId={FIELDID}"
Method: GET
Input: componentID(Integer): TheIDofthedesiredcomponent
recordId(Integer): TheIDfortheindividualrecordwithinthecomponent
fieldId(Integer): TheIDfortheindividualfieldwithinthecomponent
Permissions: TheauthenticationaccountmusthaveReadGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**

TheGetRecordAttachmentsretrievesalistofalloftheattachmentsforagivenfieldonarecord.
GetRecordAttachmentsusesthedefaultGETmethod,sothemethoddoesnotneedtobespecifiedintherequest.
ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
"http://keylight.lockpath.com:4443/ComponentService/GetRecordAttachments?componentId=12345&r
ecordId=1&fieldId=1234"
```

**XML RESPONSE**
<AttachmentInfoListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<AttachmentInfo>
<FileName>Attachment1.txt</FileName>
<FieldId>1234</FieldId>
<DocumentId>1</DocumentId>
</AttachmentInfo>
<AttachmentInfo>
<FileName>Attachment2.xml</FileName>
<FieldId>1234</FieldId>
<DocumentId>2</DocumentId>
</AttachmentInfo>
</AttachmentInfoList>

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
"http://keylight.lockpath.com:4443/ComponentService/GetRecordAttachments?componentId=12345&r
ecordId=1&fieldId=1234"

**JSON RESPONSE**
[
{
"FileName":"Attachment1.txt",
"FieldId": "1234",
"DocumentId": "1"
},
{
"FileName":"Attachment2.xml",
"FieldId": "1234",
"DocumentId": "2"
}
]


## GetWorkflow

```
URL: http://[instancename]:[port]/ComponentService/GetWorkflow?id=[ID]
Method: GET
Input: ID:  TheIDofthedesiredworkflow
Permissions: Theauthenticationaccountmusthave:ReadAdministrativeAccesspermissionforthespecific
componentenabled.
```
RetrievesworkflowdetailsandallworkflowstagesspecifiedbyID.TheIDforaworkflowmaybefoundbyusing
GetWorkflows.

**Examples**
Thissampleobtainsthedetailsforaworkflowandallworkflowstages.GetWorkflowusesthedefaultGETmethod,
sothemethoddoesnotneedtobespecifiedintherequest.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
http://keylight.lockpath.com:4443/ComponentService/GetWorkflow?id=1
XML RESPONSE
<WorkflowItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>1</Id>
<Name>DefaultWorkflow</Name>
<Description/>
<IsActive>true</IsActive>
<IsDefault>true</IsDefault>
<RoutingCriteria/>
<WorkflowOwnerGroups/>
<WorkflowOwnerUsers/>
<WorkflowStages>
<WorkflowStage>
<Id>1</Id>
<Name>GrammaticalReview</Name>
<Description/>
<IsInitial>true</IsInitial>
<IsActive>true</IsActive>
<IsVoting>false</IsVoting>
```

<GroupAccess>
<Permission>
<Group>
<Id>8</Id>
<Name>ComplianceDocumentAuthors</Name>
<IsBusinessUnit>false</IsBusinessUnit>
</Group>
<CanViewAll>false</CanViewAll>
<CanEdit>true</CanEdit>
<CanTransition>true</CanTransition>
</Permission>
<Permission>
<Group>
<Id>9</Id>
<Name>ComplianceDocumentApprovers</Name>
<IsBusinessUnit>false</IsBusinessUnit>
</Group>
<CanViewAll>true</CanViewAll>
<CanEdit>true</CanEdit>
<CanTransition>true</CanTransition>
</Permission>
</GroupAccess>
<UserAccess/>
<UseAssignments>true</UseAssignments>
<UseAssignmentValues>
<UseAssignment>
<AssignmentFieldPath>
<Field>
<Id>10</Id>
<Name>CreatedBy</Name>
<SystemName>CreatedBy</SystemName>
<FieldType>5</FieldType>


</Field>
</AssignmentFieldPath>
<CanAssigneeEdit>true</CanAssigneeEdit>
<CanAssigneeTransition>true</CanAssigneeTransition>
</UseAssignment>
<UseAssignment>
<AssignmentFieldPath>
<Field>
<Id>11</Id>
<Name>UpdatedBy</Name>
<SystemName>UpdatedBy</SystemName>
<FieldType>5</FieldType>
</Field>
</AssignmentFieldPath>
<CanAssigneeEdit>true</CanAssigneeEdit>
<CanAssigneeTransition>true</CanAssigneeTransition>
</UseAssignment>
</UseAssignmentValues>
<Transitions>
<Transition>
<Id>1</Id>
<Label>Promote</Label>
<ToStage>
<Id>2</Id>
<Name>Signoff</Name>
</ToStage>
</Transition>
</Transitions>
<CanAutoApprove>false</CanAutoApprove>
</WorkflowStage>
</WorkflowStages>
</WorkflowItem>


**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
[http://keylight.lockpath.com:4443/ComponentService/GetWorkflow?id=1](http://keylight.lockpath.com:4443/ComponentService/GetWorkflow?id=1)

**JSON RESPONSE**
{
"Id": "1",
"Name":"Default Workflow",
"IsActive":"true",
"IsDefault": "true",
"RoutingCriteria": [],
"WorkflowOwnerGroups": [],
"WorkflowOwnerUsers": [],
"WorkflowStages": {
"WorkflowStage":{
"Id": "1",
"Name":"GrammaticalReview",
"Description": [],
"IsInitial":"true",
"IsActive":"true",
"IsVoting":"false",
"GroupAccess": [
{
"Group":{
"Id": "8",
"Name":"ComplianceDocumentAuthors",
"IsBusinessUnit": "false"
},
"CanViewAll": "false",
"CanEdit": "true",
"CanTransition":"true"
},
{
"Group":{
"Id": "9",


"Name":"ComplianceDocumentApprovers",
"IsBusinessUnit": "false"
},
"CanViewAll": "true",
"CanEdit": "true",
"CanTransition":"true"
}
],
"UserAccess": [],
"UseAssignments": true,
"UseAssignmentValues": [
{
"AssignmentFieldPath": [
{
"Id": 8182,
"Name":"CreatedBy",
"SystemName": "CreatedBy",
"FieldType": 5
}
],
"CanAssigneeEdit": true,
"CanAssigneeTransition":true
},
{
"AssignmentFieldPath": [
{
"Id": 8185,
"Name":"UpdatedBy",
"SystemName": "UpdatedBy",
"FieldType": 5
}
],


"CanAssigneeEdit": true,
"CanAssigneeTransition":true
}
],
"Transitions": [
{
"Id": 73,
"Label":"Approve",
"ToStage": {
"Id": 302,
"Name":"Stage 2"
}
}
],
"CanAutoApprove": false
},
{
"Id": 302,
"Name":"Stage 2",
"Description": "",
"IsInitial":false,
"IsActive":true,
"IsVoting":false,
"GroupAccess": [
{
"Group":{
"Id": 0,
"Name":"Everyone"
},
"CanViewAll": true,
"CanEdit": true,
"CanTransition":true


### }

### ],

"UserAccess": [],
"UseAssignments": true,
"UseAssignmentValues": [
{
"AssignmentFieldPath": [
{
"Id": 8182,
"Name":"CreatedBy",
"SystemName": "CreatedBy",
"FieldType": 5
}
],
"CanAssigneeEdit": true,
"CanAssigneeTransition":true
},
{
"AssignmentFieldPath": [
{
"Id": 8185,
"Name":"UpdatedBy",
"SystemName": "UpdatedBy",
"FieldType": 5
}
],
"CanAssigneeEdit": true,
"CanAssigneeTransition":true
}
],
"Transitions": [
{


"Id": 75,
"Label":"Approve",
"ToStage": {
"Id": 300,
"Name":"Published"
}
},
{
"Id": 74,
"Label":"Reject",
"ToStage": {
"Id": 301,
"Name":"Stage 1"
}
}
],
"CanAutoApprove": false
}
]
}


## GetWorkflows

RetrievesallworkflowsforacomponentspecifiedbyitsAlias.Acomponentisauser-defineddataobjectsuchasa
customcontenttable.ThecomponentAliasmaybefoundbyusingGetComponentList(ShortName).

```
URL: http://[instancename]:[port]/ComponentService/GetWorkflows?componentalias=[Alias]
Method: GET
Input: Alias(String):  TheAliasofthedesiredcomponent
Permissions: Theauthenticationaccountmusthave:ReadAdministrativeAccesspermissionforthespecific
componentenabled.
```
**Examples**

ThissampleobtainsalistoftheworkflowsforaspecifiedcomponentwithintheKeylightPlatform.GetWorkflows
usesthedefaultGETmethod,sothemethoddoesnotneedtobespecifiedintherequest.ThecURL-boptionis
usedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8"
http://keylight.lockpath.com:4443/ComponentService/GetWorkflows?componentalias=Devices
XML RESPONSE
<WorkflowListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Workflow>
<Id>2</Id>
<Name>Default</Name>
<IsActive>true</IsActive>
<IsDefault>true</IsDefault>
</Workflow>
</WorkflowList>
```

**JSON REQUEST (cURL)**
curl-b cookie.txt-H"Accept:application/json"
[http://keylight.lockpath.com:4443/ComponentService/GetWorkflows?componentalias=Devices](http://keylight.lockpath.com:4443/ComponentService/GetWorkflows?componentalias=Devices)

**JSON RESPONSE**
[
{
"Id": 2,
"Name":"Default",
"IsActive":true,
"IsDefault":true
}
]


## TransitionRecord

Transitionarecordinaworkflowstage.

```
URL: http://[instancename]:[port]/ComponentService/TransitionRecord
Method: POST
Input: tableAlias(string):  TheAliasforthetable
recordId(integer): TheIDoftherecordtobetransitioned
transitionId(integer): TheIDoftheworkflowstagetransition,whichcanberetrieved
withGetWorkflow
Permissions: TheauthenticationaccountmusthaveReadandUpdateGeneralAccesspermissionstothe
definedtable,ViewandTransitionworkflowstagepermissions,andrecordpermission.
```
**Examples**
TransitionRecordtransitionsarecordinaworkflowstage.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@TransitionRecord.xml
"http://keylight.lockpath.com:4443/ComponentService/TransitionRecord"
XMLREQUEST(TransitionRecord.xml)
<TransitionRecord>
<tableAlias>Devices</tableAlias>
<recordId>2</recordId>
<transitionId>42</transitionId>
</TransitionRecord>
XML RESPONSE
true
JSON REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST
```
- d@TransitionRecord.json
[http://keylight.lockpath.com:4443/ComponentService/TransitionRecord](http://keylight.lockpath.com:4443/ComponentService/TransitionRecord)


**JSONREQUEST(TransitionRecord.json)**
{
"tableAlias": "Devices",
"recordId":"2",
"transitionId":"42"
}

**JSONRESPONSE**
true


## VoteRecord

Castavoteforarecordinaworkflowstage.

```
URL: http://[instancename]:[port]/ComponentService/VoteRecord
Method: POST
Input: tableAlias(string):  TheAliasforthetable
recordId(integer): TheIDoftherecordtobetransitioned
transitionId(integer): TheIDoftheworkflowstagevotingrule,whichcanberetrieved
withGetWorkflow
votingComments(string): Votingcomments
Permissions: TheauthenticationaccountmusthaveReadandUpdateGeneralAccesspermissionstothe
definedtable,ViewandVoteworkflowstagepermissions,andrecordpermission.
```
**Examples**
VoteRecordcastsavoteforarecordinaworkflowstage.ThecURL-boptionisusedtoprovideauthentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@VoteRecord.xml
"http://keylight.lockpath.com:4443/ComponentService/VoteRecord"
XMLREQUEST(VoteRecord.xml)
<VoteRecord>
<tableAlias>Devices</tableAlias>
<recordId>4</recordId>
<transitionId>46</transitionId>
<votingComments>idk</votingComments>
</VoteRecord>
XML RESPONSE
true
JSON REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST
```
- d@VoteRecord.json
[http://keylight.lockpath.com:4443/ComponentService/VoteRecord](http://keylight.lockpath.com:4443/ComponentService/VoteRecord)


**JSONREQUEST(VoteRecord.json)**
{
"tableAlias": "Devices",
"recordId":"4",
"transitionId":"46",
"votingComments": "idk"
}

**JSONRESPONSE**
true


## CreateRecord

CreateanewrecordwithinthespecifiedcomponentoftheKeylightapplication.

```
NOTE: TheRequiredoptionforafieldisonlyenforcedthroughtheuserinterface,notthroughtheAPI.
Therefore,CreateRecorddoesnotenforcetheRequiredoptionforfields.
```
```
URL: http://[instancename]:[port]/ComponentService/CreateRecord
Method: POST
Input: componentId(int):  TheIDofthedesiredcomponent
dynamicRecord(DynamicRecordItem): Fieldsforthecomponenttobecreated.
Dynamic
Record:
```
```
Adynamicrecordisdefinedbykey-valuepairsthatcontainfieldID(thatdatawillbeenteredinto)
andvaluecontainsthetype(string,decimal,etc.)ofthedataandthedataitself.Samplexmlis
shownbelowwithanentryforeachapplicablefieldtype.
<dynamicRecordxmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<FieldValues>
<!--Text-->
<KeyValuePair>
<key>3664</key>
<value i:type="a: string ">SeeSpotRun</value>
</KeyValuePair>
<!--Numeric-->
<KeyValuePair>
<key>3667</key>
<value i:type="a: decimal ">25.13</value>
</KeyValuePair>
<!--IPAddress-->
<KeyValuePair>
<key>3668</key>
<value i:type="a: string ">192.168.1.3</value>
</KeyValuePair>
```

<!--Yes/No-->
<KeyValuePair>
<key>3670</key>
<valuei:type="a: **boolean** ">true</value>
</KeyValuePair>
<!--Date-->
<KeyValuePair>
<key>3719</key>
<value i:type="a: **dateTime** ">2014-09-19T11:02:46</value>
</KeyValuePair>
<!--1:1Lookup-->
<KeyValuePair>
<key>3667</key>
<value i:type=' **DynamicRecordItem** '><Id>18</Id></value>
</KeyValuePair>
<!--1:MLookup-->
<KeyValuePair>
<key>3720</key>
<value i:type='DynamicRecordList'>
<Record><Id>13</Id></Record>
<Record><Id>20</Id></Record>
</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
EmptyFields: IfafieldisnotincludedintheinputforCreateRecord,thefieldremainsempty/nullforthecreated
record.
Anothermethodtocreateempty/nulldataforafieldthatisdefinedintheinputistouse:
<valuei:nil="true"/>asthe **value**
Matrix: Matrixrecordscanonlybecreatedaftertheparentrecordhasbeencreated.TheMatrix
componentIdcanberetrievedwithGetComponentListandtheMatrixColumnfieldscanbe
retrievedwithGetFieldList,usingtheMatrixcomponentId.MatrixRowID’smustberetrievedfrom
thetableintheKeylightdatabase.
Master/Detail: Master/Detailrecordscanonlybecreatedaftertheparentrecordhasbeencreated.The
Master/DetailcomponentIdcanberetrievedwithGetComponentListandthemaster/detail
subfieldscanberetrievedwithGetFieldList,usingtheMaster/DetailcomponentId.


WorkflowStage
ID:

ThekeyistheWorkflowStagefieldIDandtheIdisWorkflowStageID.
<KeyValuePair>
<key>3849</key>
<value i:type="DynamicRecordItem"><Id>109</Id></value>
</KeyValuePair>
Permissions: Theauthenticationaccountmusthave:
l CreateGeneralAccesspermissiontotheselectedcomponent
l Editpermissiontoanyfieldintowhichdataistobeentered
SystemFields: KeylightPlatformtrackssystemfieldsforeachrecord.Theusershouldentervaluesfortheir
customcreatedfieldsandtheplatformwillpopulatethesystemfields.Thevaluesforsystem
fieldswillbereturnedintheresponse.
**SystemFields
Field ValueSource**
CreatedAt TimeStampRecordCreated
CreatedBy UserId(APIlogon)
Id UniqueRecordIdentifier
CurrentRevision TracksRevisionHistoryStartsat 0
UpdatedAt TimeStampRecordUpdated
UpdatedBy UserId(APIlogon)
WorkflowStage WorkflowStageforRecordDefinedintheplatform


**Examples**
ThecURL-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@CreateRecordInput.xml
http://keylight.lockpath.com:4443/ComponentService/CreateRecord
XMLREQUEST(CreateRecord.xml)
<CreateRecord>
<componentId>10001</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<FieldValues>
<KeyValuePair>
<key>11</key>
<value i:type="a:string">192168001001</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</CreateRecord>
XMLRESPONSE
<DynamicRecordItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>1</Id>
<DisplayName/>
<FieldValues>
<KeyValuePair>
<key>10</key>
<valuei:nil="true"/>
</KeyValuePair>
<KeyValuePair>
<key>1628</key>
<valuei:type="DynamicRecordList"/>
</KeyValuePair>
```

<KeyValuePair>
<key>301</key>
<valuei:type="a:dateTime">2014-07-11T10:38:17.8901765-06:00</value>
</KeyValuePair>
<KeyValuePair>
<key>303</key>
<valuei:type="DynamicRecordItem">
<Id>11</Id>
<DisplayName>Last, First</DisplayName>
<FieldValues/>
</value>
</KeyValuePair>
</FieldValues>
</DynamicRecordItem>

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@CreateRecord.json
[http://keylight.lockpath.com:4443/ComponentService/CreateRecord](http://keylight.lockpath.com:4443/ComponentService/CreateRecord)

**JSONREQUEST(CreateRecord.json)**
{
"componentId": "10001",
"dynamicRecord": {
"FieldValues": [
{
"key": "3",
"value":"API ExampleDNSName"
},
{
"key": "9",
"value": 123
},
{
"key": "10",
"value":"12/25/2017"
},


### {

```
"key": "11",
"value":"1.2.3.4"
},
{
"key": "4879",
"value":true
},
```
{
"key": "23",
"value":
{
"Id": "1"
}
},
{
"key": "294",
"value":
[
{
"Id": "2"
},
{
"Id": "3"
} ] } ] } }

**JSONRESPONSE**
GetRecord


**Master/DetailExamples**

ThecURL-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-bcookie.txt -H "content-type:application/xml;charset=utf-8" -X POST-d
@CreateMDRecordInput.xml
http://keylight.lockpath.com:4444/ComponentService/CreateRecord
XMLREQUEST(CreateMDRecord.xml)
<CreateRecord>
<!--Master/Detail-->
<componentId>10199</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<FieldValues>
<!--ParentRecord Field-->
<KeyValuePair>
<key>3750</key>
<value i:type="a: int ">5</value>
</KeyValuePair>
<!--Master/DetailText-->
<KeyValuePair>
<key>3664</key>
<value i:type="a: string ">SeeSpotRun</value>
</KeyValuePair>
<!--Master/DetailNumeric-->
<KeyValuePair>
<key>3667</key>
<value i:type="a: decimal ">25.13</value>
</KeyValuePair>
<!--Master/Detail Date-->
<KeyValuePair>
<key>3719</key>
<valuei:type="a: dateTime ">2014-09-19T11:02:46</value>
</KeyValuePair>
```

<!--IPAddress-->
<KeyValuePair>
<key>3668</key>
<value i:type="a: **string** ">192.168.1.3</value>
</KeyValuePair>
<!--Master/DetailYes/No-->
<KeyValuePair>
<key>3670</key>
<value i:type="a: **boolean** ">true</value>
</KeyValuePair>
<!--Master/Detail1:1Lookup-->
<KeyValuePair>
<key>3667</key>
<value i:type=' **DynamicRecordItem** '><Id>18</Id></value>
</KeyValuePair>
<!--Master/Detail1:MLookup-->
<KeyValuePair>
<key>3720</key>
<value i:type=' **DynamicRecordList** '>
<Record><Id>13</Id></Record>
<Record><Id>20</Id></Record>
</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</CreateRecord>


## UpdateRecord

Updatefieldsinaspecifiedrecord.

```
NOTE: TheRequiredoptionforafieldisonlyenforcedthroughtheuserinterface,notthroughtheAPI.
Therefore,UpdateRecorddoesnotenforcetheRequiredoptionforfields.Theresponsewillinclude
thecompletesetoffieldsforthespecifiedrecord.
```
```
URL: http://[instancename]:[port]/ComponentService/UpdateRecord
Method: POST
Input: componentId(int):  TheIDofthedesiredcomponent
dynamicRecord(DynamicRecordItem): Fieldsforthecomponenttobecreated.
Dynamic
Record:
```
```
Adynamicrecordisdefinedbykey-valuepairsthatcontainfieldID(thatdatawillbeenteredinto)
andvaluecontainsthetype(string,decimal,etc.)ofthedataandthedataitself.Samplexmlis
shownbelowwithanentryforeachapplicablefieldtype.
<dynamicRecordxmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<FieldValues>
<!--Text-->
<KeyValuePair>
<key>3664</key>
<value i:type="a: string ">SeeSpotRun</value>
</KeyValuePair>
<!--Numeric-->
<KeyValuePair>
<key>3667</key>
<value i:type="a: decimal ">25.13</value>
</KeyValuePair>
<!--Date-->
<KeyValuePair>
<key>3719</key>
<value i:type="a: dateTime ">2014-09-19T11:02:46</value>
</KeyValuePair>
```

<!--IPAddress-->
<KeyValuePair>
<key>3668</key>
<value i:type="a: **string** ">192.168.1.3</value>
</KeyValuePair>
<!--Yes/No-->
<KeyValuePair>
<key>3670</key>
<value i:type="a: **boolean** ">true</value>
</KeyValuePair>
<!--1:1Lookup-->
<KeyValuePair>
<key>3667</key>
<value i:type=' **DynamicRecordItem** '><Id>18</Id></value>
</KeyValuePair>
<!--1:MLookup-->
<KeyValuePair>
<key>3720</key>
<value i:type='DynamicRecordList'>
<Record><Id>13</Id></Record>
<Record><Id>20</Id></Record>
</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
EmptyFields: Toempty/nulldataforafieldthatisdefinedintheinput,use<valuei:nil="true"/>asthevalue.
Matrix: TheMatrixcomponentIdcanberetrievedwithGetComponentListandtheMatrixColumnfields
canberetrievedwithGetFieldList,usingtheMatrixcomponentId.MatrixRowID’smustbe
retrievedfromthetableintheKeylightdatabase.


Master/Detail: TheMaster/DetailcomponentIdcanberetrievedwithGetComponentListandthemaster/detail
subfieldscanberetrievedwithGetFieldList,usingtheMaster/DetailcomponentId.
WorkflowStage
ID:

ThekeyistheWorkflowStagefieldIDandtheIdisWorkflowStageID.
<KeyValuePair>
<key>3849</key>
<value i:type="DynamicRecordItem"><Id>109</Id></value>
</KeyValuePair>
Permissions: Theauthenticationaccountmusthave:
l Read/UpdateGeneralAccesspermissiontotheselectedcomponent
l Editpermissionforfieldstobeupdated
l Readpermissiontotheselectedrecord


**Examples**
ThecURL-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@UpdateRecordInput.xml
http://keylight.lockpath.com:4443/ComponentService/UpdateRecord
XMLREQUEST(UpdateRecord.xml)
<UpdateRecord>
<componentId>10001</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<Id>1</Id>
<FieldValues>
<KeyValuePair>
<key>9</key>
<value i:type="a:decimal">100.00</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</UpdateRecord>
XMLRESPONSE
<DynamicRecordItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>1</Id>
<DisplayName>192.168.1.84</DisplayName>
<FieldValues>
<KeyValuePair>
<key>10</key>
<valuei:nil="true"/>
</KeyValuePair>
<KeyValuePair>
<key>9</key>
<valuei:type="a:decimal">100.00</value>
</KeyValuePair>
</FieldValues/>
</DynamicRecordItem>
```

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@UpdateRecord.json
[http://keylight.lockpath.com:4443/ComponentService/UpdateRecord](http://keylight.lockpath.com:4443/ComponentService/UpdateRecord)

**JSONREQUEST(UpdateRecord.json)**
{
"componentId": "10001",
"dynamicRecord": {
"Id": "2",
"FieldValues": [
{
"key": "3",
"value":"API ExampleDNSNameupdated"
},
{
"key": "9",
"value": 1234
},
{
"key": "10",
"value":"12/25/2018"
},
{
"key": "11",
"value":"1.2.3.5"
},
{
"key": "4879",
"value":false
},

```
{
"key": "23",
```

"value":
{
"Id": "1"
}
},
{
"key": "294",
"value":
[
{
"Id": "4"
},
{
"Id": "5"
} ] } ] } }

**JSONRESPONSE**
GetRecord


**MatrixFields**
Matrixfieldscanonlybeupdatedaftertheparentrecordiscreated.
TheessentialcomponentsofaMatrixfieldupdateare:

```
componentId: TheIDoftheMatrixfieldfoundinGetComponentList.
KeyValuePairs: Creatingamatrixrow:
l ParentRecordId,foundinGetFieldListforthematrixfieldcomponentId
l Value,parentrecordId
KeyValuePairs: Updatingamatrixrow:
l ThecomponentmatrixcellIdforthatentry
l MatrixRowId,foundinthegetfieldlistforthematrixcomponent
l Value,matrixrowsignifierfromwithinthematrix,foundinthegetfieldlistfortheparent
recordcomponent
l MatrixColumnId,foundinthegetfieldlistforthematrixcomponent
l Value(s),actualentryintotheintendedmatrixcell(s)
```
OnlyoneMatrixRowId/recordisupdatedperscriptandthescriptmustchangebetweenupdatingamatrixthathas
novaluesinacellversusupdatingamatrixthatholdsanexistingvalue.

```
MatrixExamples
XMLREQUEST(cURL)
curl-bcookie.txt -H "content-type:application/xml;charset=utf-8" -X POST-d
@MatrixUpdate.xml http://keylight.lockpath.com:4444/ComponentService/UpdateRecord
XMLREQUEST(MatrixUpdate.xml)
UpdatinganemptyMatrixfield:
<UpdateRecord>
<componentId>10164</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<FieldValues>
<KeyValuePair>
<key>2918</key>
<value i:type="a:int">5</value>
</KeyValuePair>
<KeyValuePair>
<key>2919</key>
```

<value i:type="a:int">101</value>
</KeyValuePair>
<KeyValuePair>
<key>2921</key>
<value i:type="a:decimal">8888</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</UpdateRecord>
**UpdatingaMatrixfieldwithanexistingvalue:**
<UpdateRecord>
<componentId>10164</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<Id>7</Id>
<FieldValues>
<KeyValuePair>
<key>2921</key>
<value i:type="a:decimal">333</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</UpdateRecord>


**XMLRESPONSE**
<DynamicRecordItem xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<Id>11</Id>
<DisplayName>11</DisplayName>
<FieldValues>
<KeyValuePair>
<key>2911</key>
<value i:type="a:int">11</value>
</KeyValuePair>
<KeyValuePair>
<key>2912</key>
<value i:type="a:dateTime">2014-05-06T11:34:27.8017443-05:00</value>
</KeyValuePair>
<KeyValuePair>
<key>2913</key>
<value i:type="a:dateTime">2014-05-06T11:34:27.8017443-05:00</value>
</KeyValuePair>
<KeyValuePair>
<key>2914</key>
<value i:type="DynamicRecordItem">
<Id>72</Id>
<DisplayName>Frank,Irma</DisplayName>
<FieldValues/>
</value>
</KeyValuePair>
<KeyValuePair>
<key>2915</key>
<value i:type="DynamicRecordItem">
<Id>72</Id>
<DisplayName>Frank,Irma</DisplayName>
<FieldValues/>
</value>
</KeyValuePair>


<KeyValuePair>
<key>2918</key>
<value i:type="DynamicRecordItem">
<Id>6</Id>
<DisplayName/>
<FieldValues/>
</value>
</KeyValuePair>
<KeyValuePair>
<key>2919</key>
<value i:type="DynamicRecordItem">
<Id>100</Id>
<DisplayName>Row1</DisplayName>
<FieldValues/>
</value>
</KeyValuePair>
<KeyValuePair>
<key>2921</key>
<value i:type="a:decimal"
xmlns:a="http://www.w3.org/2001/XMLSchema">2222</value>
</KeyValuePair>
<KeyValuePair>
<key>3587</key>
<value i:type="a:int"
xmlns:a="http://www.w3.org/2001/XMLSchema">1</value>
</KeyValuePair>
</FieldValues>
</DynamicRecordItem>


**Master/DetailExamples**
ThecURL-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@UpdateMDRecordInput.xml
http://keylight.lockpath.com:4444/ComponentService/UpdateRecord
XMLREQUEST(UpdateMDRecord.xml)
<UpdateRecord>
<!--Master/Detail-->
<componentId>10199</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<Id>5</Id>
<FieldValues>
<!--Master/DetailText-->
<KeyValuePair>
<key>3664</key>
<value i:type="a: string ">SeeSpot Run</value>
</KeyValuePair>
<!--Master/DetailNumeric-->
<KeyValuePair>
<key>3667</key>
<value i:type="a: decimal ">25.13</value>
</KeyValuePair>
<!--Master/DetailDate-->
<KeyValuePair>
<key>3719</key>
<value i:type="a: dateTime ">2014-09-19T11:02:46</value>
</KeyValuePair>
<!--IP Address-->
<KeyValuePair>
<key>3668</key>
<value i:type="a: string ">192.168.1.3</value>
</KeyValuePair>
<!--Master/DetailYes/No-->
<KeyValuePair>
<key>3670</key>
```

<value i:type="a: **boolean** ">true</value>
</KeyValuePair>
<!--Master/Detail1:1Lookup-->
<KeyValuePair>
<key>3667</key>
<value i:type=' **DynamicRecordItem** '><Id>18</Id></value>
</KeyValuePair>
<!--Master/Detail1:MLookup-->
<KeyValuePair>
<key>3720</key>
<value i:type=' **DynamicRecordList** '>
<Record><Id>13</Id></Record>
<Record><Id>20</Id></Record>
</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</UpdateRecord>


## UpdateRecordAttachments

Addsnewattachmentsand/orupdatesexistingattachmentstotheprovidedDocumentsfield(s)onaspecific
record,wheretheFileDataisrepresentedasaBase64string.Themaximumdatasizeoftherequestiscontrolled
bythemaxAllowedContentLengthandmaxReceivedMessageSizevaluesintheAPIweb.config.

```
URL: http://[instancename]:[port]/ComponentService/UpdateRecordAttachments
Method: POST
Input: componentID(Integer):  TheIDofthedesiredcomponent
recordId(Integer): TheIDfortheindividualrecordwithinthecomponent
fieldId(Integer): TheIDfortheindividualfieldwithinthecomponent
Master/Detail: TheMaster/DetailcomponentIdcanberetrievedwithGetComponentListandthemaster/detail
subfieldscanberetrievedwithGetFieldList,usingtheMaster/DetailcomponentId.
Permissions: TheauthenticationaccountmusthaveReadandUpdateGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**
TheUpdateRecordAttachmentsaddsnewattachmentsand/orupdatesexistingattachmentstotheprovided
documentfieldsonarecord.ThecURL-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@UpdateRecordAttachments.xml
http://keylight.lockpath.com:4443/ComponentService/UpdateRecordAttachments
XMLREQUEST(UpdateRecordAttachments.xml)
<UpdateRecordAttachments>
<componentId>12345</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<Id>1</Id>
<FieldValues>
<KeyValuePair>
<key>1234</key>
<value i:type='RecordAttachmentList'>
<Attachment>
```

<FileName>Attachment1.txt</FileName>
<FileData>SGVsbG8gV29ybGQ=</FileData>
</Attachment>
<Attachment>
<FileName>Attachment2.xml</FileName>
<FileData>SGVsbG8gV29ybGQ=</FileData>
</Attachment>
</value>
</KeyValuePair>
<KeyValuePair>
<key>5678</key>
<value i:type='RecordAttachmentList'>
<Attachment>
<FileName>Attachment3.txt</FileName>
<FileData>SGVsbG8gV29ybGQ=</FileData>
</Attachment>
</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</UpdateRecordAttachments>

**XMLRESPONSE**
<AttachmentOperationResultListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<AttachmentOperationResult>
<OperationSucceeded>true</OperationSucceeded>
<Message>Attachmentwassuccessfullyadded to theDocumentsfield.</Message>
<ComponentId>12345</ComponentId>
<RecordId>1</RecordId>
<AttachmentInfo>
<FileName>Attachment1.txt</FileName>
<FieldId>1234</FieldId>
<DocumentId>1</DocumentId>
</AttachmentInfo>
</AttachmentOperationResult>
<AttachmentOperationResult>
<OperationSucceeded>true</OperationSucceeded>
<Message>Attachmentwassuccessfullyadded to theDocumentsfield.</Message>
<ComponentId>12345</ComponentId>


<RecordId>1</RecordId>
<AttachmentInfo>
<FileName>Attachment2.xml</FileName>
<FieldId>1234</FieldId>
<DocumentId>2</DocumentId>
</AttachmentInfo>
</AttachmentOperationResult>
</AttachmentOperationResultList>

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@UpdateRecordAttachments.json
[http://keylight.lockpath.com:4443/ComponentService/UpdateRecordAttachments](http://keylight.lockpath.com:4443/ComponentService/UpdateRecordAttachments)

**JSONREQUEST(UpdateRecordAttachments.json)**
{
"componentId": "10001",
"dynamicRecord": {
"Id": "2",
"FieldValues": [
{
"key": "34",
"value":
[
{
"FileName":"import_temp.csv",
"FileData":
"VGV4dCxudW0scmljaHksaXB2NCxpcHY2LGRhdGUsZGF0ZXRpbWUNCnIxLDUxMCw8Yj5ib2xkIHRoaW5nPC9iPiwxOTI
uMTY4LjIuNCwwMDE6MGRiODowMDAwOjAwNDI6MDAwMDo4YTJlOjAzNzA6NzMzNCwyLzE4LzE5ODYsMi8xOS8xOTg2DQo
="
} ] } ] } }


**JSONRESPONSE**
[
{
"OperationSucceeded": true,
"Message": "Attachmentwassuccessfullyadded totheDocuments field.",
"ComponentId": 10001,
"RecordId":2,
"AttachmentInfo": {
"FileName":"import_temp.csv",
"FieldId": 34,
"DocumentId": 20
}
}
]


**Master/DetailExamples**
ThecURL-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@UpdateRecordAttachmentsMDInput.xml
https://keylight.lockpath.com:4443/ComponentService/UpdateRecordAttachments
XMLREQUEST(UpdateRecordAttachmentsMDInput.xml)
<UpdateRecordAttachments>
<componentId>10199</componentId>
<dynamicRecord xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<Id>36</Id>
<FieldValues>
<KeyValuePair>
<key>5045</key>
<value i:type='RecordAttachmentList'>
<Attachment>
<FileName>helloworld.txt</FileName>
<FileData>SGVsbG8gV29ybGQ=</FileData>
</Attachment>
</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</UpdateRecordAttachments>
XMLRESPONSE
<AttachmentOperationResultList
xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<AttachmentOperationResult>
<OperationSucceeded>true</OperationSucceeded>
<Message>Attachmentwassuccessfullyadded to theDocumentsfield.</Message>
<ComponentId>10199</ComponentId>
<RecordId>36</RecordId>
```

<AttachmentInfo>
<FileName>helloworld.txt</FileName>
<FieldId>5045</FieldId>
<DocumentId>45</DocumentId>
</AttachmentInfo>
</AttachmentOperationResult>
</AttachmentOperationResultList>

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@UpdateRecordAttachmentsMDInput.json
https://keylight.lockpath.com:4443/ComponentService/UpdateRecordAttachments

**JSONREQUEST(UpdateRecordAttachmentsMDInput.json)**
{
"componentId": "10199",
"dynamicRecord": {
"Id": "37",
"FieldValues": [
{
"key": "5045",
"value":
[
{
"FileName":"helloworld.txt",
"FileData":"SGVsbG8gV29ybGQ="
} ] } ] } }


**JSONRESPONSE**
[
{
"OperationSucceeded": true,
"Message": "Attachmentwassuccessfullyadded totheDocuments field.",
"ComponentId": 10199,
"RecordId":37,
"AttachmentInfo": {
"FileName":"helloworld.txt",
"FieldId": 5045,
"DocumentId": 46
}
}
]


## ImportFile

Queueajobtoimportafileforadefinedimporttemplate.

```
URL: http://[instancename]:[port]/ComponentService/ImportFile
Method: POST
Input: tableAlias(string):  TheAliasforthetabletoimportinto
importTemplateName(string): TheNameoftheimporttemplate
fileName(string): TheNameoftheimportfile
fileData(string): Base64encodedstringoffilecontents
runAsSystem(boolean): RunimportastheKeylightSystemaccountratherthan
authenticationaccount
Permissions: TheauthenticationaccountmusthaveRead,Create,Update,andImport/BulkGeneralAccess
permissionstothedefinedtable.ToenabletheRunAsSystemoption,theauthenticationaccount
musthavealsohaveRead,Create,andUpdateAdministrativeAccesspermissionstothedefined
table.
```
**Examples**
ImportFilequeuesajobtoimportafileforadefinedimporttemplate.ThecURL-boptionisusedtoprovide
authentication.

```
XML REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@ImportFile.xml
"http://keylight.lockpath.com:4443/ComponentService/ImportFile"
XMLREQUEST(ImportFile.xml)
<ImportFile>
<tableAlias>_dubs</tableAlias>
<importTemplateName>CSVImport</importTemplateName>
<fileName>import_temp.csv</fileName>
<fileData>VGV4dCxudW0scmljaHksaXB2NCxpcHY2LGRhdGUsZGF0ZXRpbWUNCnIxLDUxMCw8Yj5ib2xkIHRoaW5nPC
9iPiwxOTIuMTY4LjIuNCwwMDE6MGRiODowMDAwOjAwNDI6MDAwMDo4YTJlOjAzNzA6NzMzNCwyLzE4LzE5ODYsMi8xOS
8xOTg2DQo=</fileData>
<runAsSystem>false</runAsSystem>
</ImportFile>
XML RESPONSE
true
```

```
JSON REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST
```
- d@ImportFile.json
[http://keylight.lockpath.com:4443/ComponentService/ImportFile](http://keylight.lockpath.com:4443/ComponentService/ImportFile)
**JSONREQUEST(ImportFile.json)**
{
    "tableAlias": "_dubs",
    "importTemplateName": "CSVImport",
    "fileName":"import_temp.csv",
    "fileData":
    "VGV4dCxudW0scmljaHksaXB2NCxpcHY2LGRhdGUsZGF0ZXRpbWUNCnIxLDUxMCw8Yj5ib2xkIHRoaW5nPC9i
    PiwxOTIuMTY4LjIuNCwwMDE6MGRiODowMDAwOjAwNDI6MDAwMDo4YTJlOjAzNzA6NzMzNCwyLzE4LzE5ODYsMi8xOS8xOTg2DQo=",
    "runAsSystem": "false"
}

]

```
JSONRESPONSE
true
```

## IssueAssessments

AssessmentscanbeinitiatedviatheAPIintofieldsonDCFtablesandonMasterDetailrecords.Assessments
requirespecificdatatobeissuedviaaRequestXML file.NotethatonlyXMLrequestexamplesareavailable.

**IssueAssessments**

```
Examples:IssueAssessments
REQUEST(cURL)
curl-bcookie.txt -H "content-type:application/xml;charset=utf-8" -X POST-d
@Request.xmlhttps://keylight.lockpath.com:4443/AssessmentService/IssueAssessment >
RESULTS.xml
0_baseREQUEST(XML)
<IssueAssessment>
<assessmentIssuancexmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<ProjectId/>
<TableId/>
<FieldId/>
<ContentId/>
<VendorId/>
<IsVendorInternalMode/>
<Name/>
<TemplateId/>
<VendorContactId/>
<UserIds>x,y</UserIds>
<GroupIds>x,y</GroupIds>
<AllowDelegation/>
<AssignedUserOnly/>
<ReviewerId/>
<ShowUserScores/>
<IssuanceScheduleType/>
<IssueDate/>
<BeginningDate/>
<EndingDate/>
<RepeatUnit/>
<RepeatInterval/>
<RepeatsSunday/>
<RepeatsMonday/>
```

<RepeatsTuesday/>
<RepeatsWednesday/>
<RepeatsThursday/>
<RepeatsFriday/>
<RepeatsSaturday/>
<DueDate/>
<DueUnit/>
<DueInterval/>
<PrepopulatePriorAnswers/>
<EmailSubject/>
<EmailBody/>
<SendReviewerOrIssuerEmail/>
<SendCategoryEmail/>
<AdministrativeEmailSubject/>
<AdministrativeEmailBody/>
</assessmentIssuance>
</IssueAssessment>


**ImmediateREQUEST (XML)**
<IssueAssessment>
<assessmentIssuancexmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<ProjectId>2</ProjectId>
<Name>ImmediateScheduled Assessment</Name>
<TemplateId>13</TemplateId>
<UserIds>6,28</UserIds>
<GroupIds>7</GroupIds>
<AllowDelegation>false</AllowDelegation>
<AssignedUserOnly>true</AssignedUserOnly>
<ReviewerId>28</ReviewerId>
<ShowUserScores>true</ShowUserScores>
<IssuanceScheduleType>immediate</IssuanceScheduleType>
<DueDate>12/31/2018</DueDate>
<PrepopulatePriorAnswers>false</PrepopulatePriorAnswers>
<EmailSubject>ImmediateScheduled EmailSubject</EmailSubject>
<EmailBody>Immediate ScheduledEmail Body</EmailBody>
</assessmentIssuance>
</IssueAssessment>


**OnetimeREQUEST (XML)**
<IssueAssessment>
<assessmentIssuancexmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<ProjectId>2</ProjectId>
<Name>One-TimeScheduled Assessment</Name>
<TemplateId>13</TemplateId>
<UserIds>6,28</UserIds>
<GroupIds>7</GroupIds>
<AllowDelegation>false</AllowDelegation>
<AssignedUserOnly>true</AssignedUserOnly>
<ReviewerId>28</ReviewerId>
<ShowUserScores>true</ShowUserScores>
<IssuanceScheduleType>onetime</IssuanceScheduleType>
<IssueDate>07/01/2018</IssueDate>
<DueDate>12/31/2018</DueDate>
<PrepopulatePriorAnswers>true</PrepopulatePriorAnswers>
<EmailSubject>One-TimeScheduled EmailSubject</EmailSubject>
<EmailBody>One-TimeScheduled EmailBody</EmailBody>
</assessmentIssuance>
</IssueAssessment>

**RecurringREQUEST (XML)**
<IssueAssessment>
<assessmentIssuancexmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<TableId>10001</TableId>
<FieldId>35</FieldId>
<ContentId>64</ContentId>
<Name>RecurringScheduled Assessment API</Name>
<TemplateId>53</TemplateId>
<UserIds>27</UserIds>
<GroupIds>17</GroupIds>
<AllowDelegation>false</AllowDelegation>
<AssignedUserOnly>true</AssignedUserOnly>
<ReviewerId>10</ReviewerId>
<ShowUserScores>true</ShowUserScores>
<IssuanceScheduleType>recurring</IssuanceScheduleType>


<BeginningDate>03/10/2018</BeginningDate>
<RepeatUnit>monthly</RepeatUnit>
<EndingDate>11/05/2018</EndingDate>
<RepeatInterval>1</RepeatInterval>
<DueUnit>daily</DueUnit>
<DueInterval>1</DueInterval>
<EmailSubject>RecurringScheduled EmailSubjectAPI</EmailSubject>
<EmailBody>Recurring ScheduledEmail SubjectAPI</EmailBody>
<SendReviewerOrIssuerEmail>true</SendReviewerOrIssuerEmail>
<AdministrativeEmailSubject>Recurring ReviewerEmail Subject
API</AdministrativeEmailSubject>
<AdministrativeEmailBody>Recurring ReviewerEmail Body
API</AdministrativeEmailBody>
</assessmentIssuance>
</IssueAssessment>

**VendorREQUEST (XML)**
<IssueAssessment>
<assessmentIssuancexmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<TableId>10066</TableId>
<FieldId>1439</FieldId>
<ContentId>15</ContentId>
<VendorId>15</VendorId>
<Name>vendor assessmentAPI[VendorName]</Name>
<TemplateId>53</TemplateId>
<VendorContactId>44</VendorContactId>
<AllowDelegation>false</AllowDelegation>
<AssignedUserOnly>true</AssignedUserOnly>
<ReviewerId>10</ReviewerId>
<ShowUserScores>true</ShowUserScores>
<IssuanceScheduleType>recurring</IssuanceScheduleType>
<BeginningDate>03/08/2018</BeginningDate>
<RepeatUnit>Monthly</RepeatUnit>
<EndingDate>11/05/2018</EndingDate>
<RepeatInterval>1</RepeatInterval>
<DueUnit>Weeks</DueUnit>
<DueInterval>1</DueInterval>
<EmailSubject>RecurringScheduled EmailSubjectAPIVendor</EmailSubject>


<EmailBody>Recurring ScheduledEmail SubjectAPI[VendorContact]</EmailBody>
<SendReviewerOrIssuerEmail>true</SendReviewerOrIssuerEmail>
<AdministrativeEmailSubject>Recurring ReviewerEmail SubjectAPI
Vendor</AdministrativeEmailSubject>
<AdministrativeEmailBody>RecurringVendor</AdministrativeEmailBody> ReviewerEmail BodyAPI
</assessmentIssuance>
</IssueAssessment>

**VendorImmediateAssessmentemailformatREQUEST (XML)**
<IssueAssessment>
<assessmentIssuancexmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<TableId>10066</TableId>
<FieldId>1439</FieldId>
<ContentId>15</ContentId>
<VendorId>15</VendorId>
<Name>ImmediateVendor Assessment API 2 [VendorName]</Name>
<TemplateId>53</TemplateId>
<VendorContactId>72</VendorContactId>
<AllowDelegation>false</AllowDelegation>
<AssignedUserOnly>true</AssignedUserOnly>
<ReviewerId>10</ReviewerId>
<ShowUserScores>true</ShowUserScores>
<IssuanceScheduleType>immediate</IssuanceScheduleType>
<DueDate>03/30/2018</DueDate>
<PrepopulatePriorAnswers>false</PrepopulatePriorAnswers>
<EmailSubject>ImmediateVm Scheduled EmailSubject</EmailSubject>
<EmailBody>ImmedateVm Scheduled EmailTakethis assessmentimmediately
[VendorContact].
TableId = VendorProfiles
FieldId = Assessments
ContentId =record id
Vendor Id= NewVendor Profile-MayBeDeletedQuickly
TemplateId =Generate FindingswithAttachments[AssessmentUrl]
[AssessmentName]
Vendor ContactId= BobJones
ReviewerId =Betty Barnes
[VendorContact],&lt;br /&gt;
&lt;br /&gt;


An assessmenthasbeen issuedto [VendorName]with youasthespecified
contact.To beginworkingon theassessment,logintotheKeylight Vm
portal andenterthecredentialsissued in apreviousemail. Submit the
assessment forreviewonce youhavefinishedanswering allquestions.
&lt;ul&gt;
&lt;li&gt;Keylight VmPortal URL:[SiteUrl]&lt;/li&gt;
&lt;li&gt;AssessmentName: [AssessmentUrl]&lt;/li&gt;
&lt;li&gt;AssessmentDueDate: [DueDate]&lt;/li&gt;
&lt;/ul&gt;
Thankyou,&lt;br /&gt;
&lt;br /&gt;
Keylight Vmteam</EmailBody>
<SendReviewerOrIssuerEmail>true</SendReviewerOrIssuerEmail>
<AdministrativeEmailSubject>ReviewerSubject</AdministrativeEmailSubject> EmailforImmediate VmScheduled Email
<AdministrativeEmailBody>Reviewer EmailforImmediate Vm ScheduledEmail Subject
TableId = VendorProfiles
FieldId = Assessments
ContentId =record id
Vendor Id= NewVendor Profile-MayBeDeletedQuickly
TemplateId =Generate FindingswithAttachments[AssessmentUrl]
[AssessmentName]
Vendor ContactId= BobJones
ReviewerId =Betty Barnes</AdministrativeEmailBody>
</assessmentIssuance>
</IssueAssessment>

**RESULTS (XML)**
<AssessmentIssuanceItemxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<ProjectId>1</ProjectId>
<TableIdi:nil="true"/>
<FieldIdi:nil="true"/>
<ContentId i:nil="true"/>
<VendorIdi:nil="true"/>
<IsVendorInternalModei:nil="true"/>
<Name>ImmediateScheduledAssessment APICM</Name>
<TemplateId>11</TemplateId>
<UserIds>27</UserIds>
<VendorContactIdi:nil="true"/>
<GroupIds>17</GroupIds>
<AllowDelegation>false</AllowDelegation>


<AssignedUserOnly>true</AssignedUserOnly>
<ReviewerId>10</ReviewerId>
<ShowUserScores>true</ShowUserScores>
<IssuanceScheduleType>immediate</IssuanceScheduleType>
<BeginningDate i:nil="true"/><IssueDatei:nil="true"/>
<DueDate>03/15/2018</DueDate>
<EndingDatei:nil="true"/>
<RepeatUniti:nil="true"/>
<RepeatIntervali:nil="true"/>
<RepeatsSunday i:nil="true"/>
<RepeatsMonday i:nil="true"/>
<RepeatsTuesdayi:nil="true"/>
<RepeatsWednesdayi:nil="true"/>
<RepeatsThursdayi:nil="true"/>
<RepeatsFriday i:nil="true"/>
<RepeatsSaturdayi:nil="true"/>
<DueUniti:nil="true"/>
<DueIntervali:nil="true"/>
<PrepopulatePriorAnswers>false</PrepopulatePriorAnswers>
<EmailSubject>ImmediateScheduledEmail Subject</EmailSubject>
<EmailBody>ImmediateScheduled EmailTakethis assessmentimmediately.</EmailBody>
<SendReviewerOrIssuerEmail i:nil="true"/>
<SendCategoryEmail i:nil="true"/>
<AdministrativeEmailSubjecti:nil="true"/>
<AdministrativeEmailBodyi:nil="true"/>
</AssessmentIssuanceItem>

```
SpecialCase:AssessmentIssuedfromMasterDetaillevelrecord
TableId: IdfortheMasterDetailtableinthemasterrecord
FieldId: IdfortheAssessmentfieldintheMDrecord
ContentId: IdfortheMDrecord
```

**VendorImmediateAssessmentonMasterDetailrecordREQUEST (XML)**
<IssueAssessment>
<assessmentIssuancexmlns:i="http://www.w3.org/2001/XMLSchema-instance"
xmlns:a="http://www.w3.org/2001/XMLSchema">
<TableId>10145</TableId>
<FieldId>2816</FieldId>
<ContentId>4</ContentId>
<VendorId>1</VendorId>
<Name>vendor assessmentAPI[VendorName] testit toMD field</Name>
<TemplateId>53</TemplateId>
<VendorContactId>61</VendorContactId>
<AllowDelegation>false</AllowDelegation>
<AssignedUserOnly>true</AssignedUserOnly>
<ReviewerId>10</ReviewerId>
<ShowUserScores>true</ShowUserScores>
<IssuanceScheduleType>immediate</IssuanceScheduleType>
<DueDate>04/30/2018</DueDate>
<PrepopulatePriorAnswers>false</PrepopulatePriorAnswers>
<EmailSubject>ImmediateVendor Assessment APIMD VMEmail Subject</EmailSubject>
<EmailBody>Immediateimmediately[VendorContact].</EmailBody>VendorAssessment APIMD VM Takethisassessment
</assessmentIssuance>
</IssueAssessment>


## DeleteRecord

Deleteaselectedrecordfromwithinachosencomponent.

```
IMPORTANT: DeleteRecordwillupdatetherecord,makingitsoitwillnolongerbeviewablewithin
KeylightPlatform.Recordsaresoft-deletedtomaintainanyhistoricalreferencestotherecordandcan
berestoredwithadatabasescript.
```
```
URL: http://[instancename]:[port]/ComponentService/DeleteRecord
Method: DELETE
Input: componentID(Integer):  TheIDofthedesiredcomponent
recordId(Integer): TheIDfortheindividualrecordwithinthecomponent
Permissions: Theauthenticationaccountmusthave:
l Read/DeleteGeneralAccesspermissiontotheselectedcomponent
l Readpermissionstotheselectedrecord
```
**Examples**

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XDELETE –d
@DeleteRecord.xml
http://keylight.lockpath.com:4443/ComponentService/DeleteRecord
XMLREQUEST(DeleteRecord.xml)
<DeleteRecord>
<componentId>10001</componentId>
<recordId>1</recordId>
</DeleteRecord>
XMLRESPONSE
true
JSONREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X
DELETE-d @DeleteRecord.json
http://keylight.lockpath.com:4443/ComponentService/DeleteRecord
```

**JSONREQUEST(DeleteRecord.json)**
{
"componentId": "10001",
"recordId":"1"
}

**JSONRESPONSE**
true


## DeleteRecordAttachments

Deletesthespecifiedattachmentsfromtheprovideddocumentfieldsonaspecificrecord.

```
URL: "http://[instancename]:[port]/ComponentService/DeleteRecordAttachments"
Method: POST
Input: componentID(Integer): TheIDofthedesiredcomponent
recordId(Integer): TheIDfortheindividualrecordwithinthecomponent
fieldId(Integer): TheIDfortheindividualfieldwithinthecomponent
attachmentId(Integer): TheIDfortheindividualattachmentwithinthecomponent
Permissions: TheauthenticationaccountmusthaveReadandDeleteGeneralAccesspermissionsto:
l Selectedcomponent
l Selectedrecord
l Applicablefieldsinthecomponent(table)
```
**Examples**
TheDeleteRecordAttachmentsdeletesoneormoreattachmentsfromtheprovideddocumentfieldsonarecord.
ThecURL-boptionisusedtoprovideauthentication.

```
XMLREQUEST(cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@DeleteRecordAttachments.xml
"http://keylight.lockpath.com:4443/ComponentService/DeleteRecordAttachments"
XMLREQUEST(DeleteRecordAttachments.xml)
<DeleteRecordAttachments>
<componentId>12345</componentId>
<dynamicRecordxmlns:a="http://www.w3.org/2001/XMLSchema">xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
<Id>1</Id>
<FieldValues>
<KeyValuePair>
<key>1234</key>
<value i:type='DynamicRecordList'>
<Record>
<Id>1</Id>
</Record>
<Record>
```

<Id>2</Id>
</Record>
</value>
</KeyValuePair>
</FieldValues>
</dynamicRecord>
</DeleteRecordAttachments>

**XMLRESPONSE**
<AttachmentOperationResultListxmlns:i="http://www.w3.org/2001/XMLSchema-instance">
<AttachmentOperationResult>
<OperationSucceeded>true</OperationSucceeded>
<Message>Attachmentwassuccessfullydeletedfrom theDocuments
field.</Message>
<ComponentId>12345</ComponentId>
<RecordId>1</RecordId>
<AttachmentInfo>
<FileName>Attachment1.txt</FileName>
<FieldId>1234</FieldId>
<DocumentId>1</DocumentId>
</AttachmentInfo>
</AttachmentOperationResult>
<AttachmentOperationResult>
<OperationSucceeded>true</OperationSucceeded>
<Message>Attachmentfield.</Message> wassuccessfullydeletedfrom theDocuments
<ComponentId>12345</ComponentId>
<RecordId>1</RecordId>
<AttachmentInfo>
<FileName>Attachment2.xml</FileName>
<FieldId>1234</FieldId>
<DocumentId>2</DocumentId>
</AttachmentInfo>
</AttachmentOperationResult>
</AttachmentOperationResultList>

**JSONREQUEST(cURL)**
curl-b cookie.txt-H"content-type: application/json"-H"Accept:application/json" -X POST

- d@DeleteRecordAttachments.json
[http://keylight.lockpath.com:4443/ComponentService/DeleteRecordAttachments](http://keylight.lockpath.com:4443/ComponentService/DeleteRecordAttachments)


**JSONREQUEST(DeleteRecordAttachments.json)**
{
"componentId": "10001",
"dynamicRecord": {
"Id": "2",
"FieldValues": [
{
"key": "34",
"value":
[
{
"Id": "20"
} ] } ] } }

**JSONRESPONSE**
[
{
"OperationSucceeded": true,
"Message": "AttachmentwassuccessfullydeletedfromtheDocuments field.",
"ComponentId": 10001,
"RecordId":2,
"AttachmentInfo": {
"FileName":"import_temp.csv",
"FieldId": 34,
"DocumentId": 20
}
}
]


# Appendices


```
ThisappendixprovidestheuniqueidentifiersforthefieldtypeinaKeylighttable.
```
A: FieldTypes


## UniqueIdentifiersforFieldTypes

TheKeylightPlatformusesseveralfieldtypeseachrepresentedbyauniqueID.ThisuniqueIDisusedtodescribe
thedatainGetComponentandGetField.

```
FieldTypes
ID Type
1 Text
2 Numeric
3 Date
4 IP Address
5 Lookup
6 Master/Detail
7 Matrix
8 Documents
9 Assessments
10 Yes/No
```

```
ThisappendixincludesthebasiscURLcommandswitches.
```
B: cURLCommandSwitches


## BasiccURLCommandSwitches

SomebasiccURLcommandswitchesthatmaybehelpful:

```
Switches
Switch Option Use
```
- b cookie Includecookie
- c cookie-jar Storecookie
- H header Includexmlheaderinformation,forexample,Content-Type
- X UsetoswitchtoPOSTorDELETE
- d data XML bodyrequest,use@filename.xmltospecifyaninputfile


```
Thisappendixprovidesthefiltersforsearchcriteria.
```
C: Filtering


## SearchFilters

SearchfiltersmaybeusedwiththeGetRecordsorGetRecordCountmethods.Avarietyoffiltersareavailableand
anunlimitednumberofsearchcriteriamaybeappliedtoeachtransactionthatsupportsfiltering.Afilteris
composedofapath,type,andvalue.Theformatofafilterisshownbelow.
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>path</int>
</FieldPath>
<FilterType>ID</FilterType>
<Value>value</Value>
</SearchCriteriaItem>
</filters>

**FieldPath**

FieldPathistheKeylightcomponentcolumnthatwillbesortedon.ItdescribesthecolumnIDwherethedatais
stored.BecausetheKeylightPlatformsupportsmultiplelookupfieldreferencedatatypes,multiplepointsmaybe
requiredtodescribethepathtothecolumnId.TheGetFields()actiondescribedintheAPIcanprovidetheFieldID
numberforanyDCFcomponent.
Inthisexample,thefieldpathforModelis8676.Thefilterinputwouldbeasfollows:
<Field Path>
<int>8676</int>
</FieldPath>

```
GetFields(Equipment)
Id Name Field Type
8684 Serial Text
8670 Make Text
8676 Model Text
8683 Building Lookup
```
```
GetFields(Facility)
Id Name FieldType
9658 Building Text
9661 Address Text
9663 State Lookup
9671 Zip Numeric
```

```
GetRecords
Serial Make Model Room
67847 Dell M4600 C27
A1234567 HP H45000 C27
67849 Dell M6600 A123
B78888998889 Lenovo T420 C28
```
IntheEquipmenttable,theRoomisalookupvaluetotheroomsfieldoftheFacilitytable.Thevalueforthefieldis
referencedintheEquipmenttablebutactuallystoredintheFacilitytable.Thefieldpathsearchfilterparametermust
describetherelationship.Ifasearchfilterisfilteringequipmentbasedonthebuildinginwhichitislocated,thepath
willbe:
<Field Path>
<int>9658</int>
<int>8683</int>
</FieldPath>

**FilterTypes**

TheFilterTypedescribestheintegerIDforthefilterbeingapplied.Thetablebelowdescribestheavailablefilter
types.Thexmlsyntaxfor"contains"is:
<FilterType>1</FilterType>

```
FilterTypes
ID Filter ID Filter ID Filter
1 Contains 8 < 15 IsNull
2 Excludes 9 >= 16 Is NotNull
3 StartsWith 10 <= 10001 Offset
4 EndsWith 11 Between 10002 ContainsAny
5 = 12 NotBetween 10003 ContainsOnly
6 <> 13 IsEmpty 10004 ContainsNone
7 > 14 IsNotEmpty 10005 ContainsAtLeast
```

**Value**

Valuedescribesthecomparisonthatthecolumnwillbemeasuredagainst.Forexample,tofilterallDellcomputers
thevaluewouldbe"Dell".Andappearas:
<Value>Dell</Value>
Forthefilteroptions 11 and12,twovaluesarerequiredthataredelimitedbyapipe(|).
<Value>100|200</Value>
For13- 16 novalueswillberequired.
ContainsfiltersapplyonlytoOne-to-ManyLookupfields.

**SearchCriteriaItem**
BycombiningFieldPath,Filter,andValue,acompletefilter(denotedinXMLasSearchCriteriaItem)iscreated.
Multiplefilterscanbestackedtocreatethedesiredsearchparameters.
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>path</int>
</FieldPath>
<FilterType>ID</FilterType>
<Value>value</Value>
</SearchCriteriaItem>
</filters>


**Examples**

```
REQUEST (cURL)
curl-b cookie.txt-H"content-type: application/xml;charset=utf-8" -XPOST -d
@GetRecordsInput.xmlhttp://keylight.lockpath.com:4443/ComponentService/GetRecords
REQUEST(XML)
SampleFilteronaLookupField:
<GetRecords>
<componentId>10001</componentId>
<pageIndex>0</pageIndex>
<pageSize>100</pageSize>
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>307</int>
<int>23</int>
</FieldPath>
<FilterType>5</FilterType>
<Value>4</Value>
</SearchCriteriaItem>
</filters>
</GetRecords>
Theaboverequestwillget 100 recordswiththeDeviceTypeIdof 4 (FIREWALL)fromthe 10001 (Devices)
component.ItisshowingafilterontheDeviceTypefield.<int>307</int>istheFieldidforDeviceTypefieldon
theDevicesTable.<int>23</int>istheFieldidfortheIdfieldfromtheLUtable,DeviceTypes.
SampleFilteronaWorkflowStage:
<GetRecords>
<componentId>10001</componentId>
<pageIndex>0</pageIndex>
<pageSize>100</pageSize>
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>351</int>
<int>232</int>
</FieldPath>
```

```
<FilterType>1</FilterType>
<Value>Publish</Value>
</SearchCriteriaItem>
</filters>
</GetRecords>
```
Theaboverequestwillpull 100 recordsfromthe 10001 (Devices)tablethatcontain(FilterType1)thevalue
“Publish”.TheWorkflowStagecomponentdoesnotappearontheAPIcomponentslist.TheWorkflowStage
ComponentFieldsare 231 fortheIdfieldand 232 fortheNamefield.Seetableforadditionalsystemfield
identifiersforComponentsnotprovidedviatheAPIComponentrequest.Notethatthesesystemcomponentsdo
notofferrecordcreate,editordeleteaccess.

```
ComponentName ComponentId FieldName FieldId
Users 100 Id 321
FirstName 322
MiddleName 323
LastName 324
FullName 1335
Vendor 281
Title 265
email 266
Groups 101 Id 325
Name 326
WorkflowStage 57 Id 231
Name 232
Workflow 69 Id 570
Name 571
SampleFilteronaYes/NoField:
<GetRecords>
<componentId>10001</componentId>
<pageIndex>0</pageIndex>
<pageSize>100</pageSize>
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>5130</int>
```

</FieldPath>
<FilterType>5</FilterType>
<Value>True</Value>
</SearchCriteriaItem>
</filters>
</GetRecords>

**Samplemultiplefilterrequests:**
<GetRecords>
<componentId>10001</componentId>
<pageIndex>0</pageIndex>
<pageSize>100</pageSize>
<filters>
<SearchCriteriaItem>
<FieldPath>
<int>305</int>
<int>321</int>
</FieldPath>
<FilterType>5</FilterType>
<Value>72</Value>
</SearchCriteriaItem>
<SearchCriteriaItem>
<FieldPath>
<int>11</int>
</FieldPath>
<FilterType>15</FilterType>
</SearchCriteriaItem>
</filters>
</GetRecords>


```
ThisappendixincludeslanguageIDsthatcanbeutilizedintheGetUser,CreateUser,andUpdateUsermethods.
```
D: LanguageIdentifiers


## LanguageIDs

TheLanguageobjectoftheGetUser,CreateUser,andUpdateUsermethodsdeterminesthelanguageinthe
KeylightPlatform.InadditiontoEnglish,whichisthedefaultlanguage,theKeylightPlatformprovidesother
languagesthatcanbeutilizedinthelanguageobject.
ThistableshowsalistofavailablelanguagenamesandlanguageIDs.

```
LanguageName LanguageID LanguageName LanguageID LanguageName LanguageID
Afrikaans 54 Hindi 57 Polish 21
Albanian 28 Hungarian 14 Portuguese 22
Alsatian 132 Icelandic 15 Punjabi 70
Amharic 94 Igbo 112 Quechua 107
Arabic 1 Indonesian 33 Romanian 24
Armenian 43 Inuktitut 93 Romansh 23
Assamese 77 Irish 60 Russian 25
Azerbaijani 44 isiXhosa 52 Sakha 133
Bangla 69 isiZulu 53 Sami(Northern) 59
Bashkir 109 Italian 16 Sanskrit 79
Basque 45 Japanese 17 ScottishGaelic 145
Belarusian 35 Kannada 75 Serbian 31770
Bosnian 30746 Kazakh 63 SesothosaLeboa 108
Breton 126 Khmer 83 Setswana 50
Bulgarian 2 K'iche 134 Sinhala 91
Catalan 3 Kinyarwanda 135 Slovak 27
Chinese 30724 Kiswahili 65 Slovenian 36
Corsican 131 Konkani 87 Spanish 10
Croatian 26 Korean 18 Swedish 29
Czech 5 Kyrgyz 64 Syriac 90
Danish 6 Lao 84 Tajik 40
Dari 140 Latvian 38 Tamazight 95
Divehi 101 Lithuanian 39 Tamil 73
Dutch 19 Luxembourgish 110 Tatar 68
English 9 Macedonian(FYROM) 47 Telugu 74
```

**LanguageName LanguageID LanguageName LanguageID LanguageName LanguageID**
Estonian 37 Malay 62 Thai 30
Faroese 56 Malayalam 76 Tibetan 81
Filipino 100 Maltese 58 Turkish 31
Finnish 11 Maori 129 Turkmen 66
French 12 Mapudungun 122 Ukrainian 34
Frisian 98 Marathi 78 UpperSorbian 46
Galician 86 Mohawk 124 Urdu 32
Georgian 55 Mongolian 80 Uyghur 128
German 7 Nepali 97 Uzbek 67
Greek 8 Norwegian 20 Vietnamese 42
Greenlandic 111 Occitan 130 Welsh 82
Gujarati 71 Odia 72 Wolof 136
Hausa 104 Pashto 99 Yi 120
Hebrew 13 Persian 41 Yoruba 106


```
ThisappendixprovidestroubleshootingtipsforAPIcallsandFAQs.
```
E: TroubleshootingTips


## APITroubleshooting

ThefollowingareproblemsyoumayencounterusingtheKeylightAPIandasuggestedsolutionforeach.

```
Problem Whattodo
EnableAPI 1. ConfirmtheKeylightAPIislicensed.NavigatetoSetup>
KeylightPlatform>System>Subscription/LicenseDetails.
KeylightDataAPIshouldbelistedwithinConnectors.
```
2. ConfirmthegivenuserhasAPIaccess.NavigatetoSetup>
    KeylightPlatform>Security>Users.Selecttheuserinquestion
    andconfirmtheAPIAccessfieldissettoYes.
NoteKeylightRESTAPIisavailableonlywithKeylightEnterprise
EditionorwithanadditionallicenseintheKeylightStandardEdition.
Useraccesspermissions Confirmtheuserhasappropriaterightstothecomponent(table),
workflowstageforthegivenrecord,therecorditself(restrictrecord
access)andthespecifiedfields.
Serverencounterederrorprocessing
request.Theincomingmessagehasan
unexpectedmessageformat'Raw'.
Expectedformatsarexmlorjson

```
Verifythemessageformatiscorrect.
```
```
Usingtherightmethod(GETvsPOSTvs
DELETE)
```
```
Consultthisguideforthemethodappropriatetoyourrequest.
```
```
Capitalizationoffields(forexample,
Login)
```
```
APImethodsarecasesensitive.Verifythecaseforthegiven
methodinthisguide.
Havingset-cookienotcookie Verifythecorrectcookiefileisspecifiedfromthelogin.
AvalidsessionisrequiredforAPI request Ifyoupreviouslyhadavalidcookie,thesessionhasnowexpired.
Considercreatingacustomsecurityconfigurationwithanextended
timeoutandassignthenewconfigurationtoyourAPIuser(s)ifthe
sessionisexpiringinappropriately.
Inputstringisnotinthecorrectformat Reviewthesyntaxofyourcommand.
```

**Problem Whattodo**
cURL commandresultsinerror API methodsarecasesensitive.Verifythatyouareenteringthe
propersyntaxandcaseforthecURL commandasdocumentedin
thisguide.
OrderofswitchesforcURLcommand Type _curl–help_ andreviewthecommandsintheonlinehelpor _curl–
man>Curl_Manual.txt_ andreviewthetextfileforthecompletecurl
manual.
Seehttp[s]://<machine_name>:<port>/SecurityService/helpforthe
publishedlistofcalltemplates.
Certificateproblem Usethe-kor--insecureoptionofthecurlcommandwhenanSSL
certificatewarningoccurs.
Type _curl–help_ andreviewthecommandsintheonlinehelpor _curl–
man>Curl_Manual.txt_ andreviewthetextfileforthecompletecurl
manual.


## KeylightAPIFAQ

ThefollowingarefrequentlyaskedquestionsabouttheKeylightAPI.

**InwhatKeylighteditionsaretheRESTAPIavailable?**

KeylightEnterpriseEditionandwithanadditionallicenseintheKeylightStandardEdition.TheRESTAPI isnot
availablewiththeKeylightTeamEdition.

**WhyshouldI choosetousetheKeylightAPI?**

TheKeylightAPIisextremelyusefulforbuildingautomatedlinkagestoyourinternalsystemsforperformingbi-
directionalupdates.YoucanalsousetheREST APImethodstoupdate/importone-to-manylookupfieldsforfully
managingtherecord.

**CanImodifyuserinformationusingRESTAPI?**

Yes,youcanadd,update,andassignsecurityrolestousersandgroupsusingAPIcalls.

**DoesanAPIaccounttakeupalicense?**
UserswithPortalaccessmayhaveaccesstotheKeylightAPIwithoutusinganadditionaluserlicense.Ifauser
accountisestablishedspecificallyforAPI access,theremustbeafulluserlicenseavailableforgrantingthe
appropriateaccess.

**Whatmethodsaresupported?**

TheRESTAPIsupportsthefollowingHTTPverbs:GET,POST,andDELETE.

**IstherealimittothenumberofcallsIcanmake?**

TheAPIislimitedto 10 activesessionsatonetimeandupto 20 requestscanbeprocessedpersecond.When
retrievingmultiple(bulk)records,upto1,000recordscanberequestedatonce.Messagingisprovidedifarequest
isunabletobecompletedtoallowforsubsequentattempts.

**WhycanmyusernotmakeAPIcalls?**

TheAPI accessoptionmaynotbeenabledintheuserprofile.Verifythattheuseraccountfortheuseryouwantto
useinanAPI callhasAPI access.

**WillLockpathprogramagainsttheAPIonourbehalf?**

YoucanengageLockpathProfessionalServicesforastatementofwork,whowillgatherrequirementsand
establishtheexpecteddeliverables.TheProfessionalServicesconsultantwillestimate,schedule,andcomplete
theprojecttomeetyourneeds.

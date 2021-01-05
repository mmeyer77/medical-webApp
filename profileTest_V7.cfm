<cftry>
<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective pageEncoding="UTF-8" />
<cfcontent type="text/html; charset=UTF-8">
<!---------------------------------------------------------------------------->
<!--- Template Name: profileTest.htm                                        --->
<!--- Template Compile Date/Time: 11/28/2019   13:16:02                              --->
<!--- Template Owner ID: -3606                                        --->
<!--- Template ID: 135                                        --->
<!---                                         --->
<!--- Compiler Version: 09/13/09                                        --->
<!---------------------------------------------------------------------------->

<cfparam name='Prompt1' default='0'>
<cfparam name='Prompt2' default='0'>
<cfparam name='Prompt3' default='0'>
<cfparam name='parentsWebPrint' default='0'>
<cfimport prefix='report' taglib='../../ReportTags'>

<cfif parameterExists(school) is 'No'> <cfset school = prompt1></cfif>
<cfif parameterExists(YearID) is 'No'> <cfset Yearid = prompt2></cfif>
<cfif parameterExists(Termid) is 'No'> <cfset termid = prompt3></cfif>

<cfif ParameterExists(Prompt1) is 'No'><cfset Prompt1=School></cfif> 
<cfquery name= 'QSchool' DataSource = '#dsn#' debug = 'yes'>
	Select SchoolName, Phone, 
    	Address, City, State, Zip, 
        Fax, Web, Email, 
        DistrictName, CollegeBoardSchoolCode, DefaultYearID
	from ConfigSchool
	Where SchoolCode = '#school#'
</cfquery>

<cfloop query='QSchool'>
	<cfset schoolname = schoolname>
    <cfset schoolPhone = phone>
    <cfset schoolAddress = Address>
    <cfset schoolCity = City>
    <cfset schoolState = State>
    <cfset schoolZip = Zip>
    <cfset schoolFax = Fax>
    <cfset schoolWebPage = Web>
    <cfset schoolEmail = Email>
	<cfset SchoolDefaultYearID = defaultYearID>
    <cfset DistrictName = DistrictName>
    <cfset CollegeBoardSchoolCode = CollegeBoardSchoolCode>
</cfloop>

<cfquery name= 'Q' DataSource = '#dsn#'>
	Select YearID
	From SchoolTerm T with (nolock)
	Where T.YearID=#YearID#
</cfquery>

<cfset LastTerm = Q.RecordCount>    

<cfparam name='StudentID' default='0'>
<cfparam name='GradeLEvelOverride' default=''>
<cfparam name='GradeLEvelOverride' default=''>
<!---<cfif ParameterExists(StaffID) is 'Yes' and val(StudentID) is 0>
	<cfquery name= 'QStudents' DataSource = '#dsn#' debug = 'yes'>
	SELECT Distinct s.studentid as StudentID, p.firstname as stu_firstname,p.lastname as stu_lastname,
    p.lastname + case when p.suffix <> '' then ' ' + p.suffix else '' end + ', ' +p.firstname as stu_LFName
	FROM         Person AS p with (nolock) 
			cross apply
			(	select top 1 StudentID, GradeLevel, Schoolcode, advisorID, placement, s.transcriptnote1,
					classof, nextgradelevel, nextschoolcode, status, nextstatus, 
					substatus, enrollDate, WithdrawDate, GraduationDate, SchoolID,
					PublicSchoolLocalSchool, PublicSchoolDistrict, PublicSchoolCounty, PublicSchoolState, locker1,
					locker2, combination1, combination2 
				from Person_Student AS s with (nolock)  
				where p.PersonID = s.StudentID 
				order by case when s.schoolcode = '#school#' then 0 else 1 end, s.gradelevel desc
			) s
			INNER JOIN IDList I (nolock) on I.ID=p.personid and I.StaffID=#STaffID#
			INNER JOIN COnfigSchool CS (NoLock) ON CS.Schoolcode=s.schoolcode
			LEFT OUTER JOIN	Church AS c (nolock) ON p.ChurchID = c.ChurchID
			LEFT OUTER JOIN ADDRESS as A (nolock) on p.addressid=a.addressid
			
	Order By p.lastname, p.firstname
	</cfquery>
<cfelse>
	<cfquery name= 'QStudents' DataSource = '#dsn#' debug = 'yes'>
	SELECT Distinct s.studentid as StudentID,p.firstname as stu_firstname,p.lastname as stu_lastname,
    p.lastname + case when p.suffix <> '' then ' ' + p.suffix else '' end + ', ' +p.firstname as stu_LFName,
    p.PathToPicture as Stu_picture
	FROM         Person AS p with (nolock)
			cross apply
			(	select top 1 StudentID, GradeLevel, Schoolcode, advisorID, placement, s.transcriptnote1, 
					classof, nextgradelevel, nextschoolcode, status, nextstatus, 
					substatus, enrollDate, WithdrawDate, GraduationDate, SchoolID,
					PublicSchoolLocalSchool, PublicSchoolDistrict, PublicSchoolCounty, PublicSchoolState, locker1,
					locker2, combination1, combination2 
				from Person_Student AS s with (nolock)  
				where p.PersonID = s.StudentID and s.studentID = #studentID#
				order by case when s.schoolcode = '#school#' then 0 else 1 end, s.gradelevel desc
			) s
			INNER JOIN COnfigSchool CS (NoLock) ON CS.Schoolcode=s.schoolcode
			LEFT OUTER JOIN	Church AS c (nolock) ON p.ChurchID = c.ChurchID
			LEFT OUTER JOIN ADDRESS as A (nolock) on p.addressid=a.addressid
			
	Order By p.lastname, p.firstname
	</cfquery>
   
</cfif>
<cfdump var="#QStudents#">--->


<!---<cfset total_Stu_Selected = Qstudents.recordcount>--->

<cfquery name= 'GetPrincipal' DataSource = '#dsn#'>
	Select Salutation, Firstname, Lastname, Suffix
	From Staff S with (nolock)
    	join StaffSchools SS with (nolock) on SS.SchoolCode = 'GCS1' and S.StaffID=SS.StaffID
		and S.Occupation = 'Principal' and S.Active = 1
</cfquery>
<cfset Principal= ''>
<cfset PrincipalFN = ''>
<cfset PrincipalLN = ''>
<cfset PrincipalSuffix = ''>
<cfset PrincipalSalLN=''>
<cfset PrincipalSal=''>
<cfset timeFormatted = ''>
<cfloop query='getPrincipal'>
	<cfset PrincipalSal= Salutation>
	<cfset PrincipalFN= FirstName>
	<cfset PrincipalLN=  LastName>
	<cfset PrincipalSuffix=  Suffix>	
</cfloop>
<cfquery name= 'getTimeZoneOffset' datasource = '#dsn#' debug = 'yes'>
    select dbo.GetOffsetDateTime() as Time
</cfquery>
<cfset timeFormatted = timeformat(getTimeZoneOffset.Time, 'hh:mm:ss')>
<cfimport prefix="report" taglib="../../ReportTags">
	
<cfset arrayEstudiantesmostrados = arrayNew(1)>  
	
<cfparam name="Submit" default="Setup">
	
<cfif Submit is 'Setup'>	

<cfquery name= 'QSchool' DataSource = '#dsn#' debug = 'yes'>
	Select SchoolName, Phone, 
    	Address, City, State, Zip, 
        Fax, Web, Email, 
        DistrictName, CollegeBoardSchoolCode, DefaultYearID
	from ConfigSchool
	Where SchoolCode = '#school#'
</cfquery>

<cfloop query='QSchool'>
	<cfset schoolname = schoolname>
    <cfset schoolPhone = phone>
    <cfset schoolAddress = Address>
    <cfset schoolCity = City>
    <cfset schoolState = State>
    <cfset schoolZip = Zip>
    <cfset schoolFax = Fax>
    <cfset schoolWebPage = Web>
    <cfset schoolEmail = Email>
	  <cfset SchoolDefaultYearID = defaultYearID>
    <cfset DistrictName = DistrictName>
    <cfset CollegeBoardSchoolCode = CollegeBoardSchoolCode>
</cfloop>

<cfquery name= 'Q' DataSource = '#dsn#'>
	Select YearID
	From SchoolTerm T with (nolock)
	Where T.YearID=#YearID#
</cfquery>

<cfset LastTerm = Q.RecordCount>    

<cfparam name='StudentID' default='0'>
<cfparam name='GradeLEvelOverride' default=''>
<cfparam name='GradeLEvelOverride' default=''>
<cfif ParameterExists(StaffID) is 'Yes' and val(StudentID) is 0>
	<cfquery name= 'QStudents' DataSource = '#dsn#' debug = 'yes'>
	SELECT Distinct s.studentid as StudentID,p.firstname as stu_firstname,p.lastname as stu_lastname,
    p.lastname + case when p.suffix <> '' then ' ' + p.suffix else '' end + ', ' +p.firstname as stu_LFName, p.PathToPicture as Stu_picture
	FROM         Person AS p with (nolock) 
			cross apply
			(	select top 1 StudentID, GradeLevel, Schoolcode, advisorID, placement, s.transcriptnote1,
					classof, nextgradelevel, nextschoolcode, status, nextstatus, 
					substatus, enrollDate, WithdrawDate, GraduationDate, SchoolID, 
					PublicSchoolLocalSchool, PublicSchoolDistrict, PublicSchoolCounty, PublicSchoolState, locker1,
					locker2, combination1, combination2 
				from Person_Student AS s with (nolock)  
				where p.PersonID = s.StudentID 
				order by case when s.schoolcode = '#school#' then 0 else 1 end, s.gradelevel desc
			) s
			INNER JOIN IDList I (nolock) on I.ID=p.personid and I.StaffID=#STaffID#
			INNER JOIN COnfigSchool CS (NoLock) ON CS.Schoolcode=s.schoolcode
			LEFT OUTER JOIN	Church AS c (nolock) ON p.ChurchID = c.ChurchID
			LEFT OUTER JOIN ADDRESS as A (nolock) on p.addressid=a.addressid
			
	Order By p.lastname, p.firstname
	</cfquery>
<cfelse>
	<cfquery name= 'QStudents' DataSource = '#dsn#' debug = 'yes'>
	SELECT Distinct s.studentid as StudentID,p.firstname as stu_firstname,p.lastname as stu_lastname,
    p.lastname + case when p.suffix <> '' then ' ' + p.suffix else '' end + ', ' +p.firstname as stu_LFName,
    p.PathToPicture as Stu_picture
	FROM         Person AS p with (nolock)
			cross apply
			(	select top 1 StudentID, GradeLevel, Schoolcode, advisorID, placement, s.transcriptnote1, 
					classof, nextgradelevel, nextschoolcode, status, nextstatus, 
					substatus, enrollDate, WithdrawDate, GraduationDate, SchoolID, 
					PublicSchoolLocalSchool, PublicSchoolDistrict, PublicSchoolCounty, PublicSchoolState, locker1,
					locker2, combination1, combination2 
				from Person_Student AS s with (nolock)  
				where p.PersonID = s.StudentID and s.studentID = #studentID#
				order by case when s.schoolcode = '#school#' then 0 else 1 end, s.gradelevel desc
			) s
			INNER JOIN COnfigSchool CS (NoLock) ON CS.Schoolcode=s.schoolcode
			LEFT OUTER JOIN	Church AS c (nolock) ON p.ChurchID = c.ChurchID
			LEFT OUTER JOIN ADDRESS as A (nolock) on p.addressid=a.addressid
			
	Order By p.lastname, p.firstname
	</cfquery>
</cfif>
<cfset total_Stu_Selected = Qstudents.recordcount>
<cfquery name= 'GetPrincipal' DataSource = '#dsn#'>
	Select Salutation, Firstname, Lastname, Suffix
	From Staff S with (nolock)
    	join StaffSchools SS with (nolock) on SS.SchoolCode = 'GCS1' and S.StaffID=SS.StaffID
		and S.Occupation = 'Principal' and S.Active = 1
</cfquery>
<cfset Principal= ''>
<cfset PrincipalFN = ''>
<cfset PrincipalLN = ''>
<cfset PrincipalSuffix = ''>
<cfset PrincipalSalLN=''>
<cfset PrincipalSal=''>
<cfset timeFormatted = ''>
<cfloop query='getPrincipal'>
	<cfset PrincipalSal= Salutation>
	<cfset PrincipalFN= FirstName>
	<cfset PrincipalLN=  LastName>
	<cfset PrincipalSuffix=  Suffix>	
</cfloop>
<cfquery name= 'getTimeZoneOffset' datasource = '#dsn#' debug = 'yes'>
    select dbo.GetOffsetDateTime() as Time
</cfquery>
<cfset timeFormatted = timeformat(getTimeZoneOffset.Time, 'hh:mm:ss')>
<cfimport prefix="report" taglib="../../ReportTags">
<cfoutput>
	<!DOCTYPE HTML>


<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Medical System</title>
    

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="css/medical_style.css"> 
<style>
* {
    box-sizing: border-box;
  }
/* width */
::-webkit-scrollbar {
  width: 10px;
}

/* Track */
::-webkit-scrollbar-track {
  background: ##f1f1f1; 
}
 
/* Handle */
::-webkit-scrollbar-thumb {
  background: ##5782a7; 
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: ##34558e; 
}
  body{
      background-position: top;
      background-image: url("blue-background2.jpg");
    
  }

  .navbar{
    background-color: ##fff;
    box-shadow:
  }

  .search__col, .dashboard__col{
    max-height: 84vh;
    overflow:auto;
  }

  .dashboard__col{
    background-color: rgba(255, 255, 255, 0.3);
    border-radius:.3em;
  }

  ##myInput {
    border-radius: .3em;
    background-image: url('/css/searchicon.png');
    background-position: 10px 12px;
    background-repeat: no-repeat;
    width: 100%;
    font-size: 16px;
    padding: 12px 20px 12px 40px;
    border: 1px solid ##ddd;
    margin-bottom: 12px;
  }
  .jumbotron{
    padding: 2rem 3rem;
    margin-bottom:0;
    box-shadow: 5px 5px 5px rgba(0,0,0,.125);
    background-color: rgba(255, 255, 255, 0.3);
  }
  ##myUL {
    max-height: 61vh;
    list-style-type: none;
    padding: 0;
    margin: 0;
    width: 100%;
    border-radius: .3em;

    
  }

  th {
    max-height: 
  }

  ##myUL li a {
    
    margin-top: -1px; /* Prevent double borders */
    background-color: rgba(255, 255, 255, 0.3);
    padding: 4px;
    text-decoration: none;
    font-size: 14px;
    color: black;
    display: block;
  }

  ##myUL li a:hover:not(.header) {
    background-color: ##b7c9d9;
  
  }

  .btnde-edit{
    margin-left: 3px;
    
  }

  .box{
    width: 92px;
    display: inline-block;
  }

  .col{
    padding:15px;
  }

  .sinpadding{
    padding:0;
  }

  label {
    font-weight:bold;
    font-size:13px;
  }

  form {
    margin-block-end: 0;
  }

  .student__card{
    height: max-content;
    width: 99%;
  }

  .active, .collapsible:onclick {
    background-color: ##005cb9;
}



.student__boton{
  display: flex;
    justify-content: space-between;
  cursor: pointer;
  padding: 0;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  font-size: 15px;
  background-color: ##f6f6f6;
}

.student__boton:after{
  content: '\002B';
  color: black;
  font-weight: bold;
  float: right;
  margin-left: 5px;
}

.student__boton.active:after{
  content: "\2212";
}

.active{
  opacity: 1;
  height: auto;
}

.card-body{
  opacity: 0;
  height: 0;
  padding:0;
}

.card{
  box-shadow: 5px 5px 5px rgba(0,0,0,.125);
      margin-bottom: 7px;
}

.table-bordered{
  margin-bottom: 10px;
}
               
</style>
<cfset diffhoraria =  0>
<cfset dateChanged = DateAdd("h",diffhoraria,now())>
<!---#dateTimeFormat(dateChanged,"YYYY-MM-DD hh:nn:ss tt")#<br>--->
<cfset diaSemana = DayOfWeek(dateChanged)-1>
<cfset hora = dateTimeFormat(dateChanged,"HH:nn")>
<cfquery name= 'EstanEnLaEnfermeria' DataSource = '#dsn#' debug = 'yes'>
    select distinct studentid, TIMEIN, TIMEOUT
    from StudentMedicalEvents
    where EventDate = '#dateformat(dateChanged,"YYYY-MM-DD")#'
    and DATEDIFF(HOUR,TIMEIN,'#hora#') >=0
    and DATEDIFF(MINUTE,TIMEIN,'#hora#') >=0
    and (TIMEOUT = '' 
    	or ( DATEDIFF(hour,TIMEOUT,'#hora#') <= 0
        	and DATEDIFF(MINUTE,TIMEOUT,'#hora#') <= 0)	 
        )
</cfquery>
<!---<cfdump  var="#EstanEnLaEnfermeria#">--->
<cfquery name= 'Reportado' DataSource = '#dsn#' debug = 'yes'>
    select lastname, firstname 
    from person
    where personid = #staffid#
</cfquery> 
<cfset PageCount = 0>
            <cfset myStudentssNuevoEvento = ArrayNew(2)>    
            <cfwddx action='cfml2js' input='#myStudentssNuevoEvento#' output='myStudentObject' toplevelvariable='newJavascript'>             
                           
<cfloop Query="QStudents">
	
<cfset Studentid = QStudents.Studentid> 
     
    <cfloop index="x" from = "1" to = "1">
		<cfset myStudentssNuevoEvento["#studentid#"][1] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][2] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][3] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][4] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][5] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][6] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][7] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][8] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][9] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][10] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][11] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][12] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][13] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][14] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][15] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][16] = "">
        <cfset myStudentssNuevoEvento["#studentid#"][17] = "">
    </cfloop>
     


<cfquery name= "OTC_Student" datasource = "#dsn#">
	Select *
    from OTCStudent otcS
    inner join OTCConfig otcC
            on otcS.OTCID = otcC.OTCID
    	where StudentID= #QStudents.Studentid# 
        and otcS.ALLOW = 1
   
</cfquery>

  
<cfquery name= "Medication" datasource = "#dsn#">
	Select *
    from studentmedication 
    where StudentID=#StudentID#
</cfquery>




<cfset myStudentssNuevoEvento["#studentid#"][1] = "#studentid#">


<cfset myStudentssNuevoEvento["#studentid#"][2] = "#valueList(OTC_Student.name, ',')#">
<cfset myStudentssNuevoEvento["#studentid#"][3] = "#valueList(OTC_Student.otcid, ',')#">

<cfset myStudentssNuevoEvento["#studentid#"][4] = "#valueList(Medication.Medication, ',')#">
<cfset myStudentssNuevoEvento["#studentid#"][5] = "#valueList(Medication.MedicationID, ',')#">
<script>
		<!---FUNCION PARA NUEVO EVENTO CON DATOS ESTUDIANTE---> 
    function nuevo_evento#Studentid#(idd){
		var estudiantesVisibles = [];

		document.getElementById('exampleModalLabel').innerText = "Create Event";
		document.getElementById('formsubmit_boton').innerText = "Create";
		document.getElementById('formeventdate').value = new Date().toLocaleDateString('en-US');
		document.getElementById('formdescription').innerText = "";
		document.getElementById('formreportedby').value = "#Reportado.firstname# #Reportado.lastname#";
		document.getElementById('formoutcome').innerText = "";
		document.getElementById('formtreat').innerText = "";
		//document.getElementById('formtimein').value = new Date().getTime('en-US');
		document.getElementById('formtimein').value = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
		document.getElementById('formtimeout').value = "";
		document.getElementById('formeventtype').value = "";
		document.getElementById('formtemperature').value = "";
		document.getElementById('formpersoncontacted').value = "";
		document.getElementById('formtimecontacted').value = "";
		document.getElementById('formstudent_id').value = idd;
		
      //$('##formsubmit_boton').show();
//      $('##formborrar_boton').hide();
//	  $('##formCreateEventid').prop('checked',false);
//	  $('##formEditEventid').prop('checked',true);
//	  $('##formDeleteEventid').prop('checked',false);
	  
	  	$('##formsubmit_boton').show();
        $('##formborrar_boton').hide();
        $('##formeventid').val('');
        $('##formCreateEventid').prop('checked',true);
        $('##formEditEventid').prop('checked',false);
        $('##formDeleteEventid').prop('checked',false);
    //////////FORM OTC MEDICATION//////////////
      var arrayIdsOTC = [#myStudentssNuevoEvento["#studentid#"][3]#];
	  var arrayNameOTC = "#myStudentssNuevoEvento["#studentid#"][2]#".split(',');

	  $('##formotcmedications').empty();
	  	$.each(arrayIdsOTC, function(key, value) {   
		 	$('##formotcmedications').append($("<option></option>").attr("value", value).text(arrayNameOTC[key])); 
		});

//////////FORM PRESCRIPTION//////////////
      var arrayIdsMedications = [#myStudentssNuevoEvento["#studentid#"][5]#];
	  var arrayNameMedications = "#myStudentssNuevoEvento["#studentid#"][4]#".split(',');

	  $('##formprescription').empty();
	  	$.each(arrayIdsMedications, function(key, value) {   
		 	$('##formprescription').append($("<option></option>").attr("value", value).text(arrayNameMedications[key])); 
		});



      $.each($(".card"), function() { 
                    if ($(this).css('opacity') == 1 ) { 
                      estudiantesVisibles.push($(this).attr("id"));
                      var json_arr = JSON.stringify(estudiantesVisibles); 
                      console.log(json_arr);
                      $("##student_id").val(json_arr);
                    } 
    
    });
					
			
			}
</script>




                                                 
						                
</cfloop>
<script>
	 function setname() {
      var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      var todaysdate = new Date();
     //document.getElementById('datetoday').innerText = months[todaysdate.getMonth()]+" "+todaysdate.getFullYear() +" "+todaysdate.getHours()+":"+todaysdate.getMinutes()+":"+todaysdate.getSeconds();
    }

$(document).ready(function() {
  //$('##formdescription').val('');
	$('##formCreateEventid').prop('checked',false);
	var EstudiantesAbiertos = "#ValueList(EstanEnLaEnfermeria.studentid,',')#";
	var ArrayEstudiantesAbiertos = EstudiantesAbiertos.split(',');
	//alert(ArrayEstudiantesAbiertos);
	jQuery.each( ArrayEstudiantesAbiertos, function( i, val ) {
		
	

      var x = document.getElementById(val);
		  var estudiantesVisibles = [];
$("div##"+val+"").css("opacity",1).css("display","block").css("height","max-content");
      
    
          
        });
});
</script>

<script>
<!---BUSCADOR DE LISTA DE ESTUDIANTES--->
        function myFunction() {
          // Declare variables
          var input, filter, ul, li, a, i, txtValue;
          input = document.getElementById('myInput');
          filter = input.value.toUpperCase();
          ul = document.getElementById("myUL");
          li = ul.getElementsByTagName('li');
        
          // hacer loop en la lista y ocultar los que no hacen match
          for (i = 0; i < li.length; i++) {
            a = li[i].getElementsByTagName("a")[0];
            txtValue = a.textContent || a.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
              li[i].style.display = "";
            } else {
              li[i].style.display = "none";
            }
          }
        }
		


<!---funcion para mostrar u ocultar card de estudiantes--->
    function clickReply(clicked_id) { 
          var x = document.getElementById(clicked_id);
		      var estudiantesVisibles = [];
    if (x.style.opacity == 1  ) {
      
      x.style.opacity = 0;
      x.style.height = 0;
      x.style.display ="none";
      $.each($(".card"), function() { 
                      if ($(this).css('opacity') == 1 ) { 
                        estudiantesVisibles.push($(this).attr("id"));
                        var json_arr = JSON.stringify(estudiantesVisibles); 
                        console.log(json_arr);
                        $("##student_id").val(json_arr);
                      } 
      
      });
   
    } else {
    
      
      x.style.opacity = 1;
      x.style.height = "max-content";
      x.style.display ="block";

      $.each($(".card"), function() { 
                        if ($(this).css('opacity') == 1 ) { 
                          estudiantesVisibles.push($(this).attr("id")); 
                          var json_arr = JSON.stringify(estudiantesVisibles); 
                          console.log(json_arr);
                          $("##student_id").val(json_arr);
                        } 
        
        });
  }           
        }
		
<!---funcion para expandir card de estudiantes--->

		 function mostrar_studentcard(boton) {
    boton.classList.toggle("active");
    var content = boton.nextElementSibling;
    if (content.style.height === "max-content") {
      content.style.opacity = 0;
      content.style.height = 0;
      content.style.padding = 0;
    } else {
      content.style.opacity = 1;
      content.style.height = "max-content";
      content.style.padding = "1.25rem";
    }
  }


<!---funcion para crear evento nuevo--->

    function nuevo_evento(studentid){  
          var estudiantesVisibles = [];
          document.getElementById('exampleModalLabel').innerText = "Create Event";
          document.getElementById('formsubmit_boton').innerText = "Create";
          document.getElementById('formeventdate').value = new Date().toLocaleDateString('en-US');
          document.getElementById('formdescription').innerText = "";
          document.getElementById('formreportedby').value = "#Reportado.firstname# #Reportado.lastname#";
          document.getElementById('formoutcome').innerText = "";
          document.getElementById('formtreat').innerText = "";
          //document.getElementById('formtimein').value = new Date().getTime('en-US');
          document.getElementById('formtimein').value = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
          document.getElementById('formtimeout').value = "";
          document.getElementById('formeventtype').value = "";
          document.getElementById('formtemperature').value = "";
          document.getElementById('formpersoncontacted').value = "";
          document.getElementById('formtimecontacted').value = "";
          document.getElementById('formotcmedications').value = "";
          document.getElementById('formstudent_id').value = studentid;
		  
          $('##formsubmit_boton').show();
          $('##formborrar_boton').hide();
        $('##formeventid').val('');
        $('##formCreateEventid').prop('checked',true);
        $('##formEditEventid').prop('checked',false);
        $('##formDeleteEventid').prop('checked',false);
          document.getElementById('formmedication_id').value = "";

          $.each($(".card"), function() { 
                        if ($(this).css('opacity') == 1 ) { 
                          estudiantesVisibles.push($(this).attr("id"));
                          var json_arr = JSON.stringify(estudiantesVisibles); 
                          console.log(json_arr);
                          $("##student_id").val(json_arr);
                        } 
        
        });
    }
  		
</script>

       						      
     
</head>




<body>      
<nav class="navbar navbar-light bg-light">
  <a class="navbar-brand" href="##">
    <img src="logo_is-pan.jpg" width="144" height="70" class="d-inline-block align-top" alt="" loading="lazy">
    
  </a>
</nav>


        </br></br>



<cfif parameterExists(form.formEditEventid)> <!---Validar si el form es para update o insert --->
	<!---MedicationID = '#form.formprescription#', --->
    <cfif form.formeventid is not ''>
     
        <cfquery name="medical__query" DataSource = '#dsn#' debug = 'yes' result="i">
            Update StudentMedicalEvents set
            EventDate = '#form.formeventdate#',
            Description = '#form.formdescription#',
            staff = '#form.formreportedby#',
            Outcome = '#form.formoutcome#', 
            Treatment = '#form.formtreat#',
            TimeIn = '#datetimeformat(form.formtimein,"HH:nn")#',
            TimeOut = '#datetimeformat(form.formtimeout,"HH:nn")#',
            EventType = '#form.formeventtype#',
            Temperature = '#form.formtemperature#',
            PersonContacted = '#form.formpersoncontacted#',
            TimeContacted = '#form.formtimecontacted#' ,
            <cfif parameterExists(form.formprescription)>
            	MedicationID = '#ListFirst(form.formprescription,',')#' 
            <cfelse>
            	MedicationID = '' 
            </cfif> 
            Where StudentID=#form.formstudent_id# and eventid = #form.formeventid#
        </cfquery>
        <!---DIV crea los registros de OTC ligados al Medical event id--->
        <cfif parameterExists(form.formotcmedications)>
            <div>
                <!---Borramos los registros de OTC ligados al Medical event id--->
                <cfquery name= "BORRAR_OTCAsociados" datasource = "#dsn#">
                    delete from med.PersonMedicalEventOTCconfigMM where MedicalEventID = #form.formeventid#
                </cfquery>
                <!---Creamos los registros de OTC ligados al Medical event id--->
                <cfloop list="#formotcmedications#" delimiters="," index="medicacionesSeleccionadas">
                    #medicacionesSeleccionadas#<br>
                    <cfquery name= 'insertNuevo_OTCAsociado' DataSource = '#dsn#' debug = 'yes'>
                        INSERT INTO med.PersonMedicalEventOTCconfigMM 
                                (MedicalEventID,
                                OTCConfigID
                                )
                        VALUES ('#form.formeventid#',
                                '#medicacionesSeleccionadas#'
                                )
                    </cfquery>
                </cfloop>
                <cfquery name= "OTCComprabarAsociados" datasource = "#dsn#">
                    select pmepm.*
                    from StudentMedicalEvents s
                    inner join med.PersonMedicalEventOTCconfigMM pmepm (nolock) 
                    on s.eventid=pmepm.medicaleventid
                    where s.StudentID=#form.formstudent_id#
                    and s.eventid = #form.formeventid#
                </cfquery>
                <cfdump var="#OTCComprabarAsociados#">
            </div>
        <cfelse>
        	<!---CUANDO NO SELECCIONA NINGUNA OTC MEDICACION--->
        	<div>
                <!---Borramos los registros de OTC ligados al Medical event id--->
                <cfquery name= "BORRAR_OTCAsociados" datasource = "#dsn#">
                    delete from med.PersonMedicalEventOTCconfigMM where MedicalEventID = #form.formeventid#
                </cfquery>
            </div>
        </cfif>
        <!---DIV crea las prescripciones ligadas al Medical event id--->
        <cfif parameterExists(form.formprescription)>
        	<div>
                #ListLen(form.formprescription,',')#
                <cfif ListLen(form.formprescription,',') gt 1>
					<!---Borramos los registros de prescripciones ligados al Medical event id--->
                    <cfquery name= "BORRAR_prescripcionesAsociadas" datasource = "#dsn#">
                        delete from med.PersonMedicalEventPersonMedicationMM where MedicalEventID = #form.formeventid#
                    </cfquery>
                    <!---Creamos los registros de prescripciones ligados al Medical event id--->
                    <cfloop list="#form.formprescription#" delimiters="," index="x" item="prescripcionesSeleccionadas">
                        #x# #prescripcionesSeleccionadas#<br>
                        <cfif x gt 1>
                            <cfquery name= 'insertNuevo_OTCAsociado' DataSource = '#dsn#' debug = 'yes'>
                                INSERT INTO med.PersonMedicalEventPersonMedicationMM 
                                        (MedicalEventID,
                                        MedicationID
                                        )
                                VALUES ('#form.formeventid#',
                                        '#prescripcionesSeleccionadas#'
                                        )
                            </cfquery>
                        </cfif>
                    </cfloop>
                <cfelse>
                	<!---Borramos los registros de prescripciones ligados al Medical event id--->
                    <cfquery name= "BORRAR_prescripcionesAsociadas" datasource = "#dsn#">
                        delete from med.PersonMedicalEventPersonMedicationMM where MedicalEventID = #form.formeventid#
                    </cfquery>
                </cfif>
                <cfquery name= "MedicamentosAsociadosEvento" datasource = "#dsn#">
                    select s.medicationid as medicacionEvento, pmepm.medicationid as medicacionExtra, s.eventid
                    from StudentMedicalEvents s
                    inner join med.PersonMedicalEventPersonMedicationMM pmepm (nolock) 
                    on s.eventid=pmepm.medicaleventid
                    where s.StudentID = #form.formstudent_id#
                    and s.eventid = #form.formeventid#
                    and eventdate >= '#date1#' and eventdate <= '#date2#'
                    and s.medicationid != ''
                </cfquery>
                <cfdump var="#MedicamentosAsociadosEvento#">
            </div>
        <cfelse>
        	<!---CUANDO NO SELECCIONA NINGUNA Prescripcion--->
        	<div>
                <!---Borramos los registros de OTC ligados al Medical event id--->
                <cfquery name= "BORRAR_prescripcionesAsociadas" datasource = "#dsn#">
                    delete from med.PersonMedicalEventPersonMedicationMM where MedicalEventID = #form.formeventid#
                </cfquery>
            </div>
        </cfif>
	</cfif>
<cfelseif parameterExists(form.formCreateEventid)> 
	
  	<cfquery name= 'ComprobarNuevo_evento' DataSource = '#dsn#' debug = 'yes'>
    	select * from StudentMedicalEvents
        where EventDate = '#form.formeventdate#'
        and Description = '#form.formdescription#'
        and staff = '#form.formreportedby#'
        and Outcome = '#form.formoutcome#'
        and Treatment = '#form.formtreat#'
        and TimeIn = '#datetimeformat(form.formtimein,"HH:nn")#'
        and TimeOut = '#datetimeformat(form.formtimeout,"HH:nn")#'
        and EventType = '#form.formeventtype#'
        and Temperature = '#form.formtemperature#'
        and PersonContacted = '#form.formpersoncontacted#'
        and TimeContacted = '#form.formtimecontacted#'
        and studentid = '#form.formstudent_id#'
    </cfquery>     
    <!---COMPROBAR NUEVO EVENTO--->
<!---     <cfdump var="#ComprobarNuevo_evento#"> --->
    '#form.formeventdate#',
    '#form.formdescription#',
    '#form.formreportedby#',
    '#form.formoutcome#', 
    '#form.formtreat#',
    '#datetimeformat(form.formtimein,"HH:nn")#',
    '#datetimeformat(form.formtimeout,"HH:nn")#',
    '#form.formeventtype#',
    '#form.formtemperature#',
    '#form.formpersoncontacted#',
    '#form.formtimecontacted#',
    '#form.formstudent_id#'        
    <cfif ComprobarNuevo_evento.recordCount eq 0 >
     <script>
            alert("New event created.");
            </script>
        <cfquery name= 'insertNuevo_evento' DataSource = '#dsn#' debug = 'yes' result="idNuevoEvento">
            INSERT INTO StudentMedicalEvents 
                (EventDate, Description,staff,Outcome,Treatment, TimeIn,TimeOut,EventType,Temperature,PersonContacted,
                TimeContacted,
                MedicationID,
                studentid)
            VALUES ('#form.formeventdate#',
                    '#form.formdescription#',
                    '#form.formreportedby#',
                    '#form.formoutcome#', 
                    '#form.formtreat#',
                     '#datetimeformat(form.formtimein,"HH:nn")#',
                    '#datetimeformat(form.formtimeout,"HH:nn")#',
                    '#form.formeventtype#',
                    '#form.formtemperature#',
                    '#form.formpersoncontacted#',
                    '#form.formtimecontacted#',
                    <cfif parameterExists(form.formprescription)>
                        '#ListFirst(form.formprescription,',')#', 
                    <cfelse>
                        '',
                    </cfif> 
                    '#form.formstudent_id#')
        </cfquery>
<!---         <cfdump var="#idNuevoEvento.identitycol#"> --->
        <!---DIV crea los registros de OTC ligados al Medical event id--->
        <cfif parameterExists(form.formotcmedications)>
            <div>
                <!---Creamos los registros de OTC ligados al Medical event id--->
                <cfloop list="#form.formotcmedications#" delimiters="," index="medicacionesSeleccionadas">
                    <cfquery name= 'insertNuevo_OTCAsociado' DataSource = '#dsn#' debug = 'yes'>
                        INSERT INTO med.PersonMedicalEventOTCconfigMM 
                                (MedicalEventID,
                                OTCConfigID
                                )
                        VALUES ('#idNuevoEvento.identitycol#',
                                '#medicacionesSeleccionadas#'
                                )
                    </cfquery>
                </cfloop>
                <cfquery name= "OTCComprabarAsociados" datasource = "#dsn#">
                    select pmepm.*
                    from StudentMedicalEvents s
                    inner join med.PersonMedicalEventOTCconfigMM pmepm (nolock) 
                    on s.eventid=pmepm.medicaleventid
                    where s.StudentID=#form.formstudent_id#
                    and s.eventid = #idNuevoEvento.identitycol#
                </cfquery>
                <!---<cfdump var="#OTCComprabarAsociados#">--->
            </div>	
        </cfif>
        <!---DIV crea los registros de Prescripciones ligados al Medical event id--->
        <cfif parameterExists(form.formprescription)>
        	<div>
                #ListLen(form.formprescription,',')#
                <cfif ListLen(form.formprescription,',') gt 1>
					
                    <!---Creamos los registros de prescripciones ligados al Medical event id--->
                    <cfloop list="#form.formprescription#" delimiters="," index="x" item="prescripcionesSeleccionadas">
                        #x# #prescripcionesSeleccionadas#<br>
                        <cfif x gt 1>
                            <cfquery name= 'insertNuevo_OTCAsociado' DataSource = '#dsn#' debug = 'yes'>
                                INSERT INTO med.PersonMedicalEventPersonMedicationMM 
                                        (MedicalEventID,
                                        MedicationID
                                        )
                                VALUES ('#idNuevoEvento.identitycol#',
                                        '#prescripcionesSeleccionadas#'
                                        )
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <cfquery name= "MedicamentosAsociadosEvento" datasource = "#dsn#">
                    select s.medicationid as medicacionEvento, pmepm.medicationid as medicacionExtra, s.eventid
                    from StudentMedicalEvents s
                    inner join med.PersonMedicalEventPersonMedicationMM pmepm (nolock) 
                    on s.eventid=pmepm.medicaleventid
                    where s.StudentID = #form.formstudent_id#
                    and s.eventid = #idNuevoEvento.identitycol#
                    and eventdate >= '#date1#' and eventdate <= '#date2#'
                    and s.medicationid != ''
                </cfquery>
                <cfdump var="#MedicamentosAsociadosEvento#">
            </div>
        </cfif>
        <!---Todo este div para tomar la asistencia--->
        <div>
            <cfset diffhoraria =  0>
            <cfset dateChanged = DateAdd("h",diffhoraria,now())>
            #dateTimeFormat(dateChanged,"YYYY-MM-DD hh:nn:ss tt")#<br>
            <cfset diaSemana = DayOfWeek(dateChanged)-1>
            <cfset hora = dateTimeFormat(dateChanged,"hh:nn tt")>
            #diaSemana#<br>
            <cfquery name= "horario" DataSource = "#DSN#">
                Select distinct row, SUBSTRING(TemplateTime, 1, CHARINDEX('-', TemplateTime) - 1) as horaInicio, 
                substring(templatetime,CHARINDEX('-', templatetime)+1,LEN(templatetime)-(CHARINDEX('-', templatetime))) as horaFin
                From classes C
                inner join  TimeTable TT 
                on TT.ClassID = C.classID
                inner join ScheduleTemplateTimeTable STT
                on c.Templateid = STT.Templateid
                where c.classid in (select r.classid
                                    from roster r
                                    inner join classes c
                                    on r.classid = c.classid
                                    where r.studentid = #form.formstudent_id#
                                    and c.yearid = #yearid#)
                and col = 0  
                and TemplateTime != ''
                and day = 5
                
               <!--- and CAST(SUBSTRING(TemplateTime, 1, CHARINDEX('-', TemplateTime) - 1) as Time) >=  CAST('#hora#' as Time)
                and CAST(substring(templatetime,CHARINDEX('-', templatetime)+1,LEN(templatetime)-(CHARINDEX('-', templatetime))) as Time) <=  CAST('#hora#' as Time)
                order by day--->
            </cfquery>
            <cfset horaSemana = 0>
           <!--- <cfdump var="#horario#">--->
            <cfloop query="#horario#">
                
                <cfset ComienzoClase = #timeFormat(horario.horaInicio, "HH:mm")#>
                <cfset FinClase = #timeFormat(horario.horaFin, "HH:mm")#> 
                <cfset HoraLocal = #timeFormat(hora, "HH:mm")#>
                
                
                <cfif DateCompare(HoraLocal,ComienzoClase) eq 1 and DateCompare(HoraLocal,FinClase) eq -1>
                  <!---  <br>#ComienzoClase# -> #HoraLocal# #DateCompare(HoraLocal,ComienzoClase)#< --- >#FinClase# -> #HoraLocal# #DateCompare(HoraLocal,FinClase)#<br>
                    #row#----><cfset horaSemana = row>
                </cfif>
            </cfloop>
            <cfif horaSemana neq 0>
                <cfquery name= "ClaseQueAusenta" DataSource = "#DSN#">
                    Select C.ClassID as ClassID, C.Pattern as Pattern, crs.CourseID as CourseID,
                        instr.LastName as InstrLN, instr.FirstName as InstrFN, instr.salutation as instrSal,
                        instr2.LastName as Instr2LN, instr2.FirstName as Instr2FN, instr2.salutation as instr2Sal,
                        aide.LastName as aideLN, aide.FirstName as aideFN, aide.salutation as aideSal,
                        C.Name as Name, C.Section as Section, CRS.Title as Title, Rm.Room as Room,
                        R.enrolled1 as term1, R.enrolled2 as Term2, R.enrolled3 as term3, 
                        R.enrolled4 as term4, R.enrolled5 as term5, R.enrolled6 as term6, 
                        tt.[begin] as period, tt.[day] 
                    From Roster R with (nolock)
                        join Classes C with (nolock) on R.StudentID = #form.formstudent_id#
                            and R.ClassID=C.ClassID
                            and R.Enrolled=1
                        join Classes C1 with (nolock) on C.ClassID = C1.ClassID 
                            and c.templateID=86
                        join Courses CRS with (nolock) on CRS.CourseID=C.CourseID 
                        join TimeTable TT with (nolock) on TT.ClassID = c.classID
                        Left Outer Join Rooms Rm with (nolock) On (TT.RoomID = Rm.RoomID)
                        Left Outer Join staff instr with (nolock) On (C1.StaffID = instr.staffID)
                        Left Outer Join staff Instr2 with (nolock) On (C1.altstaffID = Instr2.staffID)
                        Left Outer Join staff Aide with (nolock) On (C1.aidid = aide.staffID)
                    Where (C.YearID = #YearID# or R.AltYearID = #YearID#)
                    and R.enrolled#termid# = 1
                    and tt.[begin] = #horaSemana#
                    and tt.[day] = #diaSemana#
                    order by C.Name, C.Section
                </cfquery>
                 <!---<cfdump var="#ClaseQueAusenta.Name#"> --->
                <cfif ClaseQueAusenta.recordcount gt 0>
                <cfquery name= "AttendanceByStudentByDate" DataSource = "#DSN#">
                    Select *
                    From Attendance A
                    where StudentID = #form.formstudent_id#
                    and A.AttendanceDate >= '#DateFormat(dateChanged,"MM/DD/YYYY")#' 
                    and A.AttendanceDate <= '#DateFormat(dateChanged,"MM/DD/YYYY")#'
                    <!---and A.AttendanceCode != ''--->
                    and A.classid = #ClaseQueAusenta.classid#                 
                </cfquery>
                
                <cfif AttendanceByStudentByDate.recordcount eq 0>
                    <!---Segunda condicion OPCION 1 si el estudiante NO tiene attendance en el homeroom--------------------------->
                    <cfquery name= "AttendanceInsert" DataSource = "#DSN#" result="insert">
                        INSERT INTO Attendance
                                (AttendanceCode,
                                attendancedate,
                                classid,
                                StudentID,
                                [Column],
                                ModifiedBy,
                                ModifiedDate,
                                Notified,
                                Updated
                                )	
                                VALUES 
                                ('E',
                                '#DateFormat(dateChanged,"YYYY-MM-DD 00:00:00.0")#',
                                #ClaseQueAusenta.classid#,
                                #form.formstudent_id#,
                                1,
                                '-3263',
                                '#DateFormat(dateChanged,"MM/DD/YYYY")#',
                                0,
                                0
                                )
                    </cfquery>
                   <!--- <cfdump var="#insert#">---->
                   <script>
            alert("Codigo de enfermeria agregado a attendance de clase: #ClaseQueAusenta.Name#");
            </script>
                <cfelse>
                    <!---Segunda condicion OPCION 2 si el estudiante tiene attendance en el homeroom pero esta vacio--------------------------->
                    <cfquery name= "AttendanceByStudentByDate" DataSource = "#DSN#" result="Update">
                        Update Attendance
                        set AttendanceCode = 'E'
                        where StudentID = #form.formstudent_id#
                        and classid = #ClaseQueAusenta.classid#
                        and attendancedate = '#DateFormat(dateChanged,"MM/DD/YYYY")#'
                    </cfquery>
                    <cfdump var="#Update#">
                     <script>
            alert("Codigo de enfermeria agregado a attendance de clase: #ClaseQueAusenta.Name#");
            </script>
            </cfif>
                </cfif>
            </cfif>
        </div>
	</cfif>
<cfelseif parameterExists(form.formDeleteEventid)> 
	 
    <cfif form.formeventid is not ''>
    <cfquery name= 'ComprobarBorrar_evento' DataSource = '#dsn#' debug = 'yes'>
    	  select * from StudentMedicalEvents
        where Eventid = '#form.formeventid#'
    </cfquery> 
    <cfif ComprobarBorrar_evento.recordCount gt 0>
     <cfquery name= 'insertNuevo_evento' DataSource = '#dsn#' debug = 'yes'>
               delete from StudentMedicalEvents where eventid = #form.formeventid# and studentid = #form.formstudent_id#
        </cfquery>
        <script>
        alert("Event: #ComprobarBorrar_evento.description# was Deleted");
        </script>
    
    </cfif>
       
    </cfif>
</cfif>
        <div class="container">
        <div class="row">
                <div class="col-md-3 search__col"><!---inicio COL-MD-4--->
            
                        <div class="jumbotron" style="width: 100%; height: 100%;">
                                       
                               
                                 
                               
                            
      <div class="row">
       	<input type="text" id="myInput" style="font-family:FontAwesome" onkeyup="myFunction()" placeholder="Find a student.. &##xF002;" title="Type in a name">

                                            <ul class="overflow-auto" id="myUL">
                                            
                    <cfloop Query="QStudents">
						<cfset Studentidd = QStudents.Studentid>                     
                        <cfloop index="x" from = "1" to = "10">
                          <cfset myStudentss["#Studentidd#"][1][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][2][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][3][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][4][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][5][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][6][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][7][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][8][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][9][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][10][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][11][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][12][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][13][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][14][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][15][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][16][#x#] = "">
                          <cfset myStudentss["#Studentidd#"][17][#x#] = "">
                         </cfloop>            
                         <li id="myvalue"  onClick="clickReply(#studentidd#)"><a href="##">#stu_LFName#</a></li>
                     </cfloop>
                                            </ul>
                                           
                                          
                                               </div>    
                                           </div>
                                       </div> <!---fin COL-MD-4--->
        	                           
<div class="col-md-9 dashboard__col">    <!---INICIO DE COL-MD-8  --->
 <div class="row">   

  


<cfloop Query="QStudents">
<cfset Studentid = QStudents.Studentid> 
<cfquery name= "Qmedevent_test2" datasource = "#dsn#">
	Select *
    from OTCStudent otcS
    inner join OTCConfig otcC
            on otcS.OTCID = otcC.OTCID
    	where StudentID= #QStudents.Studentid# and otcS.ALLOW = 1
   
</cfquery>

  
<!---
<cfdump var="#Qmedevent_test#">

<cfquery name= "Qmedevent1" datasource = "#dsn#">
	Select *
    from StudentMedicalEvents
    Where StudentID=#StudentID# and eventdate >= '#date1#' and eventdate <= '#date2#'
	order by eventdate desc  
</cfquery>
 <cfdump var="#Qmedevent1#"> --->
<cfquery name= "Qmedevent_test" datasource = "#dsn#">
	Select *
    from studentmedication 
    where StudentID=#StudentID#
</cfquery>

<cfquery name= "Qmedevent" datasource = "#dsn#">
	Select CONVERT(varchar(10), EventDate, 101) as EventDate, Description, staff, Outcome, Treatment,  
    	CONVERT(varchar(10), TimeIn, 108) as TimeIn, 
        CONVERT(varchar(10), TimeOut, 108) as TimeOut,  
    	EventType, Temperature, PersonContacted, TimeContacted, Medication, EventID, s.medicationid as medication_id
    from StudentMedicalEvents s (nolock) 
    	left outer join studentmedication m (nolock) on s.medicationid=m.medicationid
    Where s.StudentID=#StudentID# and eventdate >= '#date1#' and eventdate <= '#date2#'
	order by eventdate desc  
</cfquery>
<!--- <cfdump var="#Qmedevent#" > --->
<cfset medeventCount = 0>
<cfloop query="Qmedevent">
<cfquery name= "OTCAsociadosEvento" datasource = "#dsn#">
select pmepm.otcconfigid as OTCasociado, s.eventid
from StudentMedicalEvents s
inner join med.PersonMedicalEventOTCconfigMM pmepm (nolock) 
on s.eventid=pmepm.medicaleventid
where s.StudentID=#StudentID#
and eventdate >= '#date1#' and eventdate <= '#date2#'
-- and s.medicationid != ''
and s.eventid = #Qmedevent.eventid#
</cfquery>

<cfquery name= "MedicamentosAsociadosEvento" datasource = "#dsn#">
select s.medicationid as medicacionEvento, pmepm.medicationid as medicacionExtra, s.eventid
from StudentMedicalEvents s
inner join med.PersonMedicalEventPersonMedicationMM pmepm (nolock) 
on s.eventid=pmepm.medicaleventid
where s.StudentID=#StudentID#
and s.eventid = #Qmedevent.eventid#
and eventdate >= '#date1#' and eventdate <= '#date2#'
and s.medicationid != ''
</cfquery>
<!---  <cfdump var="#MedicamentosAsociadosEvento#"> --->
<cfif Qmedevent.eventid eq 446>
<cfdump var="#OTCAsociadosEvento#">
</cfif>
<cfset medeventCount = medeventCount + 1>
<cfset myStudentss["#studentid#"][1][medeventcount] = "#Qmedevent.EventDate#">
<cfset myStudentss["#studentid#"][2][medeventcount] = "#Qmedevent.description#">
<cfset myStudentss["#studentid#"][3][medeventcount] = "#Qmedevent.staff#">
<cfset myStudentss["#studentid#"][4][medeventcount] = "#Qmedevent.Outcome#">
<cfset myStudentss["#studentid#"][5][medeventcount] = "#Qmedevent.Treatment#">
<cfset myStudentss["#studentid#"][6][medeventcount] = "#datetimeformat(Qmedevent.timein,"HH:nn tt")#"> 
<cfset myStudentss["#studentid#"][7][medeventcount] = "#datetimeformat(Qmedevent.timeout,"HH:nn tt")#">
<cfset myStudentss["#studentid#"][8][medeventcount] = "#Qmedevent.Eventtype#">
<cfset myStudentss["#studentid#"][9][medeventcount] = "#Qmedevent.temperature#">
<cfset myStudentss["#studentid#"][10][medeventcount] = "#Qmedevent.personcontacted#">
<cfset myStudentss["#studentid#"][11][medeventcount] = "#Qmedevent.timecontacted#">
<cfset myStudentss["#studentid#"][12][medeventcount] = "#Qmedevent.medication#">
<cfset myStudentss["#studentid#"][14][medeventcount] = "#studentid#">
<cfset myStudentss["#studentid#"][15][medeventcount] = "#Qmedevent.eventid#">

<cfset myStudentss["#studentid#"][16][medeventcount] = "#valueList(Qmedevent_test.medicationid, ',')#">
<cfset myStudentss["#studentid#"][17][medeventcount] = "#valueList(Qmedevent_test.medication, ',')#">
<cfset myStudentss["#studentid#"][18][medeventcount] = "#valueList(MedicamentosAsociadosEvento.medicacionExtra, ',')#,#Qmedevent.medication_id#">

<cfset myStudentss["#studentid#"][19][medeventcount] = "#valueList(OTCasociadosevento.OTCasociado, ',')#">
<cfset myStudentss["#studentid#"][20][medeventcount] = "#valueList(Qmedevent_test2.name, ',')#">
<cfset myStudentss["#studentid#"][21][medeventcount] = "#valueList(Qmedevent_test2.otcid, ',')#">

<script>
<!---FUNCION PARA TIME OUT --->
	function hora_de_salida(){
    document.getElementById('formtimeout').value = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
  }
		<!---FUNCION PARA EDITAR EVENTO ---> 
    function my#studentid#_#medeventcount#(idd){
		var estudiantesVisibles = [];
      document.getElementById('exampleModalLabel').innerText = "Edit Event";
      document.getElementById('formsubmit_boton').innerText = "Save";
	//	document.getElementById('formeventdate').value = new Date('#myStudentss["#studentid#"][1]['#medeventcount#']#').toLocaleDateString("en-US");
      document.getElementById('formeventdate').value = "#myStudentss["#studentid#"][1]['#medeventcount#']#";
			document.getElementById('formdescription').innerText = "#myStudentss["#studentid#"][2]['#medeventcount#']#";
      document.getElementById('formreportedby').value = "#myStudentss["#studentid#"][3]['#medeventcount#']#";
      document.getElementById('formoutcome').innerText = "#myStudentss["#studentid#"][4]['#medeventcount#']#";
      document.getElementById('formtreat').innerText = "#myStudentss["#studentid#"][5]['#medeventcount#']#";
      // document.getElementById('formtimein').value = "#myStudentss["#studentid#"][6]['#medeventcount#']#";
      document.getElementById('formtimein').value = "#myStudentss["#studentid#"][6]['#medeventcount#']#";
      document.getElementById('formtimeout').value = "#myStudentss["#studentid#"][7]['#medeventcount#']#";
      document.getElementById('formeventtype').value = "#myStudentss["#studentid#"][8]['#medeventcount#']#";
      document.getElementById('formtemperature').value = "#myStudentss["#studentid#"][9]['#medeventcount#']#";
      document.getElementById('formpersoncontacted').value = "#myStudentss["#studentid#"][10]['#medeventcount#']#";
      document.getElementById('formtimecontacted').value = "#myStudentss["#studentid#"][11]['#medeventcount#']#";
      document.getElementById('formotcmedications').value = "#myStudentss["#studentid#"][12]['#medeventcount#']#";
      document.getElementById('formstudent_id').value = "#myStudentss["#studentid#"][14]['#medeventcount#']#";
      document.getElementById('formeventid').value = "#myStudentss["#studentid#"][15]['#medeventcount#']#";
      <!---document.getElementById('formprescription').value = "#myStudentss["#studentid#"][16]['#medeventcount#']#";--->
      $('##formsubmit_boton').show();
      $('##formborrar_boton').hide();
	  $('##formCreateEventid').prop('checked',false);
	  $('##formEditEventid').prop('checked',true);
	  $('##formDeleteEventid').prop('checked',false);
    //////////FORM OTC MEDICATION//////////////
      var arrayIdsOTC = [#myStudentss["#studentid#"][21]['#medeventcount#']#];
	  var arrayIdsOTCSeleccionadas2 = [#myStudentss["#studentid#"][19]['#medeventcount#']#];
	  var arrayNameOTC = "#myStudentss["#studentid#"][20]['#medeventcount#']#".split(',');

	  $('##formotcmedications').empty();
	  	$.each(arrayIdsOTC, function(key, value) {   
		 	$('##formotcmedications').append($("<option></option>").attr("value", value).text(arrayNameOTC[key])); 
		});

	   	$("##formotcmedications option").each(function(){
			var seleccionada = jQuery.inArray(parseInt($(this).val()),arrayIdsOTCSeleccionadas2);
			console.log(seleccionada);
			if (seleccionada !== -1){        
			 $(this).attr("selected","selected");
			}
		 });
    //////////FORM PRESCRIPTION//////////////
      var arrayIdsMedications = [#myStudentss["#studentid#"][16]['#medeventcount#']#];
	  var arrayIdsMedicationsSeleccionadas = [#myStudentss["#studentid#"][18]['#medeventcount#']#];
	  var arrayNameMedications = "#myStudentss["#studentid#"][17]['#medeventcount#']#".split(',');

	  $('##formprescription').empty();
	  	$.each(arrayIdsMedications, function(key, value) {   
		 	$('##formprescription').append($("<option></option>").attr("value", value).text(arrayNameMedications[key])); 
		});

	   	$("##formprescription option").each(function(){
			var seleccionada = jQuery.inArray(parseInt($(this).val()),arrayIdsMedicationsSeleccionadas);
			console.log(seleccionada);
			if (seleccionada !== -1){        
			 $(this).attr("selected","selected");
			}
		 });


      $.each($(".card"), function() { 
                   debugger; if ($(this).css('opacity') == 1 && '#myStudentss["#studentid#"][7]['#medeventcount#']#' == '' ) {
                      
                      estudiantesVisibles.push($(this).attr("id"));
                      var json_arr = JSON.stringify(estudiantesVisibles); 
                      console.log(json_arr);
                      $("##student_id").val(json_arr);
                    } 
    
    });

   
					
			
			}

	<!---FUNCION PARA BORRAR EVENTO ---> 
      function borrar#studentid#_#medeventcount#(idd){
		  var estudiantesVisibles = [];
    
		document.getElementById('exampleModalLabel').innerText = "Delete Event";
		document.getElementById('formeventdate').value = "#myStudentss["#studentid#"][1]['#medeventcount#']#";
		document.getElementById('formdescription').innerText = "#myStudentss["#studentid#"][2]['#medeventcount#']#";
		document.getElementById('formreportedby').value = "#myStudentss["#studentid#"][3]['#medeventcount#']#";
		document.getElementById('formoutcome').innerText = "#myStudentss["#studentid#"][4]['#medeventcount#']#";
		document.getElementById('formtreat').innerText = "#myStudentss["#studentid#"][5]['#medeventcount#']#";
		document.getElementById('formtimein').value = "#myStudentss["#studentid#"][6]['#medeventcount#']#";
		document.getElementById('formtimeout').value = "#myStudentss["#studentid#"][7]['#medeventcount#']#";
		document.getElementById('formeventtype').value = "#myStudentss["#studentid#"][8]['#medeventcount#']#";
		document.getElementById('formtemperature').value = "#myStudentss["#studentid#"][9]['#medeventcount#']#";
		document.getElementById('formpersoncontacted').value = "#myStudentss["#studentid#"][10]['#medeventcount#']#";
		document.getElementById('formtimecontacted').value = "#myStudentss["#studentid#"][11]['#medeventcount#']#";
		document.getElementById('formotcmedications').value = "#myStudentss["#studentid#"][12]['#medeventcount#']#";
		document.getElementById('formstudent_id2').value = "#myStudentss["#studentid#"][14]['#medeventcount#']#";
		document.getElementById('formeventid2').value = "#myStudentss["#studentid#"][15]['#medeventcount#']#";
		document.getElementById('formprescription').value = "#myStudentss["#studentid#"][16]['#medeventcount#']#";
      $('##formsubmit_boton').hide();
    $('##formborrar_boton').show();
	  $('##formCreateEventid').prop('checked',false);
	  $('##formEditEventid').prop('checked',false);
	  $('##formDeleteEventid').prop('checked',true);
//////////FORM OTC MEDICATION//////////////
      var arrayIdsOTC = [#myStudentss["#studentid#"][21]['#medeventcount#']#];
	  var arrayIdsOTCSeleccionadas2 = [#myStudentss["#studentid#"][19]['#medeventcount#']#];
	  var arrayNameOTC = "#myStudentss["#studentid#"][20]['#medeventcount#']#".split(',');

	  $('##formotcmedications').empty();
	  	$.each(arrayIdsOTC, function(key, value) {   
		 	$('##formotcmedications').append($("<option></option>").attr("value", value).text(arrayNameOTC[key])); 
		});

	   	$("##formotcmedications option").each(function(){
			var seleccionada = jQuery.inArray(parseInt($(this).val()),arrayIdsOTCSeleccionadas2);
			console.log(seleccionada);
			if (seleccionada !== -1){        
			 $(this).attr("selected","selected");
			}
		 });
    //////////FORM PRESCRIPTION//////////////
      var arrayIdsMedications = [#myStudentss["#studentid#"][16]['#medeventcount#']#];
	    var arrayNameMedications = "#myStudentss["#studentid#"][17]['#medeventcount#']#".split(',');
	  $('##formprescription').empty();
	  $.each(arrayIdsMedications, function(key, value) {   
		 $('##formprescription').append($("<option></option>").attr("value", value).text(arrayNameMedications[key])); 
		});
	   
      $.each($(".card"), function() { 
                    if ($(this).css('opacity') == 1 ) { 
                      estudiantesVisibles.push($(this).attr("id"));
                      var json_arr = JSON.stringify(estudiantesVisibles); 
                      console.log(json_arr);
                      $("##student_id2").val(json_arr);
                    } 
    
    });
					
			
			}
		       
        </script>
</cfloop>


<!---CANTIDAD DE EVENTOS MEDICOS ENTRE LAS FECHAS SELECCIONADAS--->
<cfset myStudentss["#studentid#"][13][1] = "<p class='font-weight-bold'>Recent Medical Events (#medeventcount#)</p>">

<cfif ParameterExists(estudiantes_mostrados)>                        
	<cfif IsJSON(estudiantes_mostrados)>
		<cfset arrayEstudiantesmostrados = deserializeJSON(estudiantes_mostrados)>
	</cfif>
<cfelse>

</cfif>
<cfquery name= "Qallergy" datasource = "#DSN#">
        Select allergy, comment, allergyID
        from StudentAllergies with (Nolock)
        Where StudentID=#StudentID#
        order by allergyid
    </cfquery>
    					<!---INICIO DE CARD DE PERFIL  --->
          
                                    <div class="card student__card" id="#studentid#" 
                                    <cfif arrayFind(arrayEstudiantesmostrados, studentid) gt 0>
                                    style="opacity: 1;
                                          height: max-content;display: block;"
                                           
                                    <cfelse>
                                    style="
                                            opacity: 0;
                                            height: 0;
                                            display: none;
                                            "
                                    </cfif>>
                           
                          <!---BOTON DE PERFIL  --->
                          <button type="button" onClick="mostrar_studentcard(this)" class="collapsible student__boton">
                              <span class="h4 sinpadding">#stu_LFName#</span><cfif #myStudentss["#studentid#"][1][1]# eq #DateFormat(now(),'mm/dd/yyyy')#>
                              <span class="font-weight-bold sinpadding">  ~ Time in:</span> #myStudentss["#studentid#"][6][1]#
                                <cfelse>
                                    
                                </cfif>  
                              
                              
                              <a href="####" class="btnde-edit" onClick="my#studentid#_1(#studentid#)" data-toggle="modal" data-target="##events"><i class="fa fa-edit"></i></a>
                              <a href="####" class="btnde-edit" onClick="borrar#studentid#_1(#studentid#)" data-toggle="modal" data-target="##events"><i class="fa fa-trash"></i></a>
                              <a target="_blank" href="https://renweb1.renweb.com/renweb1/##/peoplemanagement/student/#studentid#/student_dashboard"  class="btn btn-outline-info"><i class="fa fa-"></i>Demographics</a>
                              <a href="##" class="btnde-crear" onClick="nuevo_evento#studentid#(#studentid#)" data-toggle="modal" data-target="##events">
                                <i class="fa fa-plus" style="font-size: 43px;"></i>
                              </a>
                           </button>
                           <!--- PERFIL  --->
                          <div class="card-body">
                          	<div class="row">
                            <div class="col-5">
                                
                                <p class="card-text"><i>&nbsp;</i>ID: #studentid#</p>
                                <p class="card-text"><i class="fa fa-calendar">&nbsp;</i>
                                Last visit: 
                                <cfif #myStudentss["#studentid#"][1][1]# eq #DateFormat(now(),'mm/dd/yyyy')#>
                                    Today
                                <cfelse>
                                    #myStudentss["#studentid#"][1][1]#
                                </cfif>  
                                </p>
                                <p class="card-text"><i >&nbsp;</i>
                                
                               <!--- ALERGIAS  --->
                               <span class="font-weight-bold">Allergies:</span><br><cfloop query="#Qallergy#">*#Qallergy.allergy#:<br>Comments: #Qallergy.comment#<br> </cfloop> </p>
                                <cfquery name= "ParentStudent" datasource = "#dsn#">
                                    select TOP 2 p.personid, p.lastname, p.firstname, p.CellPhone, p.email
                                    from Person_Family PF
                                    inner join person P
                                    on PF.personid = p.personid
                                    where pf.FamilyID in (select FamilyID
                                                        from Person_Family PF
                                                        where personid = #studentid#)
                                    and pf.parent = 1
                                    and p.deceased = 0
                                    order by pf.FamilyOrder
                                </cfquery>
<!---                                 <cfdump var="#ParentStudent#"> --->

                                
                            </div>
                              <div class="col-5">
                              
								<p class="sinpadding">
                <cfloop query='ParentStudent'>
                <span class="font-weight-bold sinpadding">Name: </span>#ParentStudent.lastname#, #ParentStudent.firstname#<br>
                <span class="font-weight-bold sinpadding">Cellphone: </span> #ParentStudent.cellphone#<br>
                <span class="font-weight-bold sinpadding">Email: </span> #ParentStudent.email#<br>
                                </cfloop>
                                </p>
							</div>
                            <div class="col-2 text-right">
								<cfif #stu_picture# is ''>
                                    <img src ='https://lin-mex.client.renweb.com/RenWeb/reports/custom/lin-mex/NoPhoto.jpg' alt="PHOTO" width="95px">
                                <cfelse>
                                    <img src ='https://#CGI.HTTP_HOST#/ftp/#dsn#/pictures/#stu_picture#' width="95px">
                                </cfif>
							</div>
                            
						</div>
<div class="col-lg-12 sinpadding" style="display: flex;">
 <div class="col-lg-6 sinpadding">
                    
            <p class="font-weight-bold">#myStudentss["#studentid#"][13][1]#</p>      
                  </div>                              
                  
                  <div class="col-lg-6 sinpadding" style="display: flex; justify-content: flex-end;">
                  
    <!---<a href="##" class="btnde-crear" onClick="nuevo_evento(#studentid#)" data-toggle="modal" data-target="##events">
      <i class="fa fa-min" style="font-size: 43px;"></i>
    </a>--->
    <a href="##" class="btnde-crear" onClick="nuevo_evento#studentid#(#studentid#)" data-toggle="modal" data-target="##events">
      <i class="fa fa-plus" style="font-size: 43px;"></i>
    </a>         
                
                  </div>  
                             </div>
                              <!---LOOP DE TABLA DE EVENTOS RECIENTES  --->
                              
                            
                            <table class="table table-sm">
  <colgroup>
  <col width="60%">
  </colgroup>
  <tbody>
    <tr>
    
      <th>Event Comment</th>
      <th>Date</th>
      <th>In/Out</th>
      <th></th>
      <th></th>
    </tr>
    <cfloop index="eventos" from=1 to = #medeventcount#>
    <tr>
    
      
      <td>#myStudentss["#studentid#"][2][eventos]#</td>
      <td>#myStudentss["#studentid#"][1][eventos]#</td>
      <td>#myStudentss["#studentid#"][6][eventos]# / #myStudentss["#studentid#"][7][eventos]#</td>
      <td><a href="####" class="btnde-edit" onClick="my#studentid#_#eventos#(#studentid#)" data-toggle="modal" data-target="##events"><i class="fa fa-edit"></i></a></td>
      <td><a href="####" class="btnde-edit" onClick="borrar#studentid#_#eventos#(#studentid#)" data-toggle="modal" data-target="##events"><i class="fa fa-trash"></i></a></td>
      
    </tr>
   </cfloop>
  </tbody>
</table>
                            <a href="####" onClick="clickReply(#studentid#)" class="btn btn-outline-info"><i class="fa fa-">&nbsp;</i>Close</a>
                          </div>
                        </div>
                                                 
						                
</cfloop>
</div><!---FIN DE CARD DE PERFIL--->  

                                                   <!---  MODAL --->

<div class="modal fade" id="events" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
        <form action="" method="post">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel"></h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
      
          <div class="modal-body">
                    

              <div class="row form-group">
              
                  <div class="col-lg-3">
                    <label>Date</label>
                    <input id="formeventdate" name="formeventdate" value=""  class="form-control">
                  
                  </div>
                  
                <div class="col-lg-3 sinpadding">

                    <div class="box time__in">
                        <label>Time in</label>
                        <input id="formtimein" name="formtimein" type="text" value="" class="form-control">
                    </div>
                     
                      <div class="box time__out">
                        <label>Time out</label> <i onCLick="hora_de_salida()" class="fa fa-clock-o" aria-hidden="true"></i>
                        <input id="formtimeout" name="formtimeout" type="text" value="" class="form-control" >
                      </div>
                      
                </div>



                    
                   

                    <div class="col-lg-6">
                        <label>Reported by</label>
                        <input id="formreportedby" name="formreportedby" type="text" value="" class="form-control">
                        
                      </div>

              </div>

              <div class="row form-group">
                  <div class="col-lg-3">
                      <label>Event Type</label>
                      <input id="formeventtype" name="formeventtype" type="text" value="" class="form-control">
                      
                    </div>

                    <div class="col-lg-2">
                        <label>Temperature</label>
                        <input id="formtemperature" name="formtemperature" value="" type="number" class="form-control" >
                        
                      </div>

              </div>

              <div class="row form-group">
                  <div class="col-lg-6">
                  	<label>Prescription</label>
                  	<select multiple id="formprescription" name="formprescription" value="" type="text" class="form-control" >
        				<option selected="selected">Choose one</option>
                <option>None</option>
              		</select>
                      
                    </div>

                    <div class="col-lg-6">
                        <label>OTC medications</label>
                        <select multiple id="formotcmedications" name="formotcmedications" value="" type="text" class="form-control" >
        				<option selected="selected">Choose one</option>
                <option>None</option>
              		</select>
                      </div>

                    </div>

                      <div class="row form-group">
                          <div class="col-lg-12">
                              <label>Description</label>
                              <textarea id="formdescription" name="formdescription" type="text" class="form-control" ></textarea>
                              
                            </div>
                          </div>

                          <div class="row form-group">
                              <div class="col-lg-12">
                                  <label>Treatment</label>
                                  <textarea id="formtreat" name="formtreat" type="text" value="" class="form-control"></textarea>
                                  
                                </div>
                              </div>

                              <div class="row form-group">
                                  <div class="col-lg-12">
                                      <label>Outcome</label>
                                      <textarea id="formoutcome" name="formoutcome" type="text"  class="form-control"></textarea>
                                      
                                    </div>
                                  </div>

                                  <div class="row form-group">
                                            <div class="col-lg-3">
                                              <label>Person contacted</label>
                                              <input id="formpersoncontacted" name="formpersoncontacted" value="" type="text" class="form-control" >
                                            </div>

                                            <div class="col-lg-9">
                                              <label>Time contacted</label>
                                              <input id="formtimecontacted" name="formtimecontacted" value="" type="number" class="form-control" >
                                            </div>
                                  </div>
                                  
                                      
                                      
                                      
                                      
                                      <input type="checkbox" id="formEditEventid" name="formEditEventid" value="" hidden>
                                      <input type="checkbox" id="formCreateEventid" name="formCreateEventid" value="" hidden>

                                      <input type="hidden" id="formeventid" name="formeventid" value="">
                                      <input hidden type="text" id="student_id" name="estudiantes_mostrados" value="">
                                      <input hidden type="text" id="formmedication_id" name="formmedication_id" value="">
                                      <input hidden type="text" id="formstudent_id" name="formstudent_id" value="">
                                      <button type="submit" id="formsubmit_boton"  class="btn btn-primary" name="submit" value="Setup"></button>
                                      <button type="button" id="formborrar_boton" class="btn btn-primary" data-toggle="modal" data-target="##delete_confirm">Delete</button>
                                     
                                      
              
              </div>
               </form>
              </div>
              </div><!---  FIN DE MODAL --->

<!---  MODAL PARA CONFIRMACION BORRAR --->
<div class="modal fade" id="delete_confirm" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <form class="modal-content" action="" method="post">
      <div class="modal-header">
        <h5 class="modal-title">Delete Event</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to delete this event?</p>
      </div>
      <div class="modal-footer">
        <input type="checkbox" id="formDeleteEventid" name="formDeleteEventid" value="" hidden>
        <input hidden type="text" id="student_id2" name="estudiantes_mostrados" value="">
        <input type="hidden" id="formeventid2" name="formeventid" value="">
        <input hidden type="text" id="formstudent_id2" name="formstudent_id" value="">
        
        
        <button type="submit" class="btn btn-primary" name="submit" value="Setup">Delete</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>

      </div>
    </form>
  </div>
</div>
	</div> 
	       
<!---FIN DE COLUMNA COL-MD-10---> 

           <!--- <div class="col-md-4">
            
 <div class="jumbotron" style="width: 100%; height: 100%;">
                
        <h1 id="datepicker" style="text-align: center;"></h1>     
     </br>
 </br>
     
                <div class="row">
                    <div class="col-md-6"> 
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Recent Events</h5>
                                <p class="card-text"></p>
                                <a href="####" class="btn btn-primary">New Events</a>
                                        </div>
                                    </div>
                             </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Assets Map</h5>
                                <p class="card-text"></p>
                                <a href="####" class="btn btn-primary"><i class="fa fa-map">&nbsp;</i>Vieew Your Map</a>
                                        </div>
                                    </div>
                    </div>
                        </div>    
                    </div>
                </div>--->
            
            </div>

        </div>
        
        

						
      
            
    </body>

</html>





	</cfoutput>
 
<cfelseif Submit is "Save">




<cfoutput>
<!DOCTYPE HTML>


<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Medical System</title>
    

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script>

$(document).ready(function() {
    //Function call
  //  console.log("#medical__query.recordCount#");
    
});

</script>
</head>
<body>

</body>

</html>

</cfoutput>


</cfif>


<cfoutput>
<Finished>	</cfoutput>

<cfcatch type="any">
		<cfoutput>
			<cfdump var="#cfcatch.tagcontext#">
			<br>Tipo de error: #cfcatch.type# <br>
			Detalle: #cfcatch.Detail# <br>
			Mensaje: #cfcatch.Message# <br>
			#cfcatch.sql#
			SQLSTATE: #cfcatch.sqlstate#
			#cfcatch.NativeErrorCode#
		</cfoutput>
	</cfcatch>
</cftry>


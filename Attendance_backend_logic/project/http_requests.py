import requests
import json
from project.utilities import extract_class_timestamps
def authenticate(username,password, host):     
    #type: (str,str,str) -> dict   
    hec_url = f'http://{host}/api/auth/authenticate'
    data={
        "username":username,
        "password":password
    }
    response = requests.post(hec_url,json=data, verify=False)
    if response.status_code == 200:
        # print(response.text)
        return json.loads(response.text)
    else:
        print(f"Failed to Authenticate. Status code: {response.status_code}, Response: {response.text}")

def getClass(class_id,token,host):
    #type: (int,str,str) -> dict   
    hec_url = f'http://{host}/api/class'
    params={
        "id":class_id
    }
    headers={
        "Authorization": "Bearer-"+token
    }
    response=requests.get(hec_url,params=params,headers=headers,verify=False)
    if response.status_code == 200:
        # print(response.text)
        return json.loads(response.text)
    else:
        print(f"Failed to get Class. Status code: {response.status_code}, Response: {response.text}")


def getClassMembers_name(class_id,token,host):
    #type: (int,str,str) -> tuple[dict,list]  
    hec_url = f'http://{host}/api/class/member/name'
    params={
        "class_id":class_id
    }
    headers={
        "Authorization": "Bearer-"+token
    }
    response=requests.get(hec_url,params=params,headers=headers,verify=False)
    if response.status_code == 200:
        # print(response.text)
        raw= json.loads(response.text)
        name_array=[]
        for key,value in dict(raw).items():
            name_array.append(key)
        return raw, name_array
    else:
        print(f"Failed to get Members name. Status code: {response.status_code}, Response: {response.text}")
 
def putMember_Class(property,value,member_id,class_id,token,host):
    #type: (str,any,int,int,str,str) -> bool   
    hec_url = f'http://{host}/api/member_class'
    data={
        "property": property,
        "value":value
    }
    params={
        "member_id": member_id,
        "class_id": class_id
    }
    headers={
        "Authorization": "Bearer-"+token
    }
    response=requests.put(hec_url,headers=headers,params=params,json=data)
    if response.status_code == 200:
        # print(response.text)
        return True
    else:
        print(f"Failed to get Members name. Status code: {response.status_code}, Response: {response.text}")
        return False
def _update_class_attendance(final_percents,facial_percents,ble_percents,member_id,class_id,token,host):
    isPresent=False
    if final_percents >=0.5: isPresent=True
    status1=putMember_Class("setPresent",isPresent,member_id,class_id,token,host)
    status2=putMember_Class("setAttendance_percents",float(final_percents),member_id,class_id,token,host)
    status3=putMember_Class("setFacial_percents",float(facial_percents),member_id,class_id,token,host)
    status4=putMember_Class("setBle_percents",float(ble_percents),member_id,class_id,token,host)
    
    # print(f"{status1} {status2}")
    return status1 and status2 and status3 and status4
    
if __name__=="__main__":
    token=authenticate("admin1","vippropassword","localhost:8080").get("token","")
    print(getClassMembers_name(class_id=1,token=token,host="localhost:8080"))
    # start_time,end_time=extract_class_timestamps(getClass(class_id=1,token=token,host="localhost:8080"))
    # print((end_time-start_time).seconds/60)
    
    # putMember_Class("setPresent",False,2,3,token,"localhost:8080")

class UserDetails{
    String username;
    String email;
    String name;
    String id;
    String photoUrl;
    List<String> ownerOfGroups;
    String status;
    String aboutMe;
    String providerDetails;
    List<ProviderDetails> providerData;
        
        UserDetails({this.providerDetails,this.username,this.photoUrl,this.email,this.providerData});
    }
    
    class ProviderDetails {
      String providerDeatils;
      ProviderDetails(this.providerDeatils);
}
#install.packages('rsconnect')


rsconnect::setAccountInfo(name='wise-jiang-kunyi', 
                          token='0330E5FB36C6F3A47F889897E7A212E8', 
                          secret='+Ja5JwIFMPAHRRMlUXyAe3q8D3s4t0xEB7IDK3+o')

library(rsconnect)
rsconnect::deployApp()

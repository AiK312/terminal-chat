FROM ubuntu:latest                                                                                     
                                                                                                       
ENV PORT="31279"                                                                                       
RUN apt update -y && apt upgrade -y                                                                    
WORKDIR /usr/chat                                                                                      
COPY chatserver .                                                                                      
CMD ["./chatserver", "31279"]                                                                          
EXPOSE $PORT
#include "log.h"
#include <iostream>

void LOG_INFO(const std::string& msg) 
{
    std::cout << "[INFO] " << msg << std::endl;
}

void LOG_WARNING(const std::string& msg) 
{
    std::cout << "[WARNING] " << msg << std::endl;
}

void LOG_ERROR(const std::string& msg) 
{
    std::cout << "[ERROR] " << msg << std::endl;
}

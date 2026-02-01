workspace {
    model {
        user = person "User"
        softwareSystem = softwareSystem "Software System" {
            webapp = container "Web Application" "Java/Spring Boot App"
            database = container "Database" "PostgreSQL"
            webapp -> database "Reads from and writes to"
        }
        user -> webapp "Uses"
    }

    deploymentEnvironment "Production" {
        deploymentNode "AWS" {
            region = deploymentNode "eu-central-1" {
                webSg = infrastructureNode "Web Security Group"
                alb = infrastructureNode "Application Load Balancer"

                az1 = deploymentNode "AZ 1" {
                    # Wir weisen die Instanz einer Variable zu
                    webappInst1 = containerInstance webapp
                }
                az2 = deploymentNode "AZ 2" {
                    webappInst2 = containerInstance webapp
                }

                dbNode = deploymentNode "RDS" {
                    dbInst = containerInstance database
                }

                # Hier korrigieren wir die Pfade:
                user -> alb "Requests"
                alb -> webappInst1 "Forwards to"
                alb -> webappInst2 "Forwards to"
                webappInst1 -> dbInst "Writes"
                webappInst2 -> dbInst "Writes"
            }
        }
    }

    views {
        deployment softwareSystem "Production" "AWS_HA" {
            include *
            autolayout lr
        }
    }
}
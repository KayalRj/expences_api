# Stage 1: Build ASP.NET Core Web API
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY expenceAPI.csproj ./
RUN dotnet restore expenceAPI.csproj

# Copy all source files and publish Release build
COPY . ./
RUN dotnet publish expenceAPI.csproj -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime container
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Render defaults or custom port
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "expenceAPI.dll"]

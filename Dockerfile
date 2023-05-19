FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5186

ENV ASPNETCORE_URLS=http://+:5186

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["wizkid.csproj", "./"]
RUN dotnet restore "wizkid.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "wizkid.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "wizkid.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "wizkid.dll"]

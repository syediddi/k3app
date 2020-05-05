FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["k3app.csproj", "./"]
RUN dotnet restore "./k3app.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "k3app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "k3app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "k3app.dll"]

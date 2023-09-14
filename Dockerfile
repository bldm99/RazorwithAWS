# Usa la imagen oficial de ASP.NET Core como imagen base
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Usa la imagen oficial de .NET Core SDK como imagen de compilación
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Asplab1/Asplab1.csproj", "Asplab1/"]
RUN dotnet restore "Asplab1/Asplab1.csproj"
COPY . .
WORKDIR "/src/Asplab1"
RUN dotnet build "Asplab1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Asplab1.csproj" -c Release -o /app/publish

# Usa la imagen base para publicar
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Asplab1.dll"]

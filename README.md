# FakeStoreAPI

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.9.1-orange.svg" />
    <img src="https://img.shields.io/badge/Xcode-15.2.X-orange.svg" />
    <img src="https://img.shields.io/badge/platforms-iOS-brightgreen.svg?style=flat" alt="iOS" />
    <a href="https://www.linkedin.com/in/rodrigo-silva-6a53ba300/" target="_blank">
        <img src="https://img.shields.io/badge/LinkedIn-@RodrigoSilva-blue.svg?style=flat" alt="LinkedIn: @RodrigoSilva" />
    </a>
</p>

iOS app developed for study purposes, consuming **FakeStoreAPI**, focused on learning **HTTP methods** and **concurrency** using **Swift async/await**.

This project explores a clean project structure, MVVM architecture, network abstraction, state handling, and unit testing.

| Feed | Details | Cart |
| --- | --- | --- |
| ![Feed](https://github.com/user-attachments/assets/63eb1d1c-e9ea-4642-85f9-ad7c6a7c8521) | ![Details](https://github.com/user-attachments/assets/c8f718a9-8772-470b-8003-ff9e6c5772e4) | ![Cart](https://github.com/user-attachments/assets/83df7a33-0adb-471b-84a9-9e34d6cdf2e4) |

## Contents

- [Features](#features)
- [Requirements](#requirements)
- [Functionalities](#functionalities)
- [Setup](#setup)

## Features

- View Code (UIKit)
- MVVM Architecture
- Swift async/await
- URLSession networking
- Unit Tests with Mocks
- Custom UI components
- Image caching with SDWebImage

## Requirements

- iOS 15.0 or later
- Xcode 15.0 or later
- Swift 5.0 or later

## Functionalities

- [x] **Products Feed**: Displays a list of products fetched from FakeStoreAPI.
- [x] **Product Details**: Shows detailed information about a selected product.
- [x] **Shopping Cart**: Allows users to add and manage products in the cart.
- [x] **Cart Management**: Handles product quantities and cart state.
- [x] **Async/Await Networking**: Uses Swift concurrency for API requests.
- [x] **MVVM Pattern**: Separates UI, business logic, and data layers.
- [x] **Unit Tests**: ViewModel tests using mocked services.
- [x] **Image Caching**: Asynchronous image loading and caching using SDWebImage.

## Setup

First of all download and install Xcode, Swift Package Manager and then clone the repository:

```
$ git@github.com:diggosilva/FakeStoreAPI.git
```

## After cloning, do the following:

```
$ cd <diretorio-base>/FakeStoreAPI/
$ open FakeStoreAPI.xcodeproj/
```

## Author

Developed for learning and experimentation with modern iOS development practices.
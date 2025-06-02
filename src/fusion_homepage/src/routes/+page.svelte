<script>
  import "../index.css";
  import { onMount } from 'svelte';
  let current_year = new Date().getFullYear();
  let latestVersion = '';
  let downloadUrl = '';

  onMount(async () => {
    try {
      const response = await fetch('https://api.github.com/repos/Zedonboy/Fusion-Wallet/releases/latest');
      const release = await response.json();
      latestVersion = release.tag_name;
      
      // Find the APK asset
      const apkAsset = release.assets.find(asset => asset.name.includes('app-release.apk'));
      if (apkAsset) {
        downloadUrl = apkAsset.browser_download_url;
      }
    } catch (e) {
      console.error('Error fetching latest version:', e);
    }
  });

  async function handleDownload() {
    if (!downloadUrl) {
      alert('Download link not available. Please try again later.');
      return;
    }
    window.location.href = downloadUrl;
  }

  // import { backend } from "$lib/canisters";

  // let greeting = "";

  // function onSubmit(event) {
  //   const name = event.target.name.value;
  //   backend.greet(name).then((response) => {
  //     greeting = response;
  //   });
  //   return false;
  // }
</script>

<header>
  <nav class="bg-white border-gray-200 px-4 lg:px-6 py-2.5 dark:bg-gray-800">
    <div
      class="flex flex-wrap justify-between items-center mx-auto max-w-screen-xl"
    >
      <a href="https://fusionwallet.me" class="flex items-center">
        <img
          src="fusion_web_logo.png"
          class="mr-3 h-6 sm:h-9"
          alt="Fusion Logo"
        />
        <span
          class="self-center text-xl font-semibold whitespace-nowrap dark:text-white"
          >Fusion</span
        >
      </a>
      <div class="flex items-center lg:order-2">
        <div class="hidden md:block">
          <a href="https://internetcomputer.org/" target="_blank">
            <img src="built_on.png" class="h-12" />
          </a>
        </div>
        <!-- <a
          href="#"
          class="text-gray-800 dark:text-white hover:bg-gray-50 focus:ring-4 focus:ring-gray-300 font-medium rounded-lg text-sm px-4 lg:px-5 py-2 lg:py-2.5 mr-2 dark:hover:bg-gray-700 focus:outline-none dark:focus:ring-gray-800"
          >Log in</a
        > -->
        <!-- <a
          href="https://github.com/Zedonboy/Fusion-Wallet/releases"
          class="text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-4 lg:px-5 py-2 lg:py-2.5 mr-2 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800"
          >Download APK</a
        > -->
        <button
          data-collapse-toggle="mobile-menu-2"
          type="button"
          class="inline-flex items-center p-2 ml-1 text-sm text-gray-500 rounded-lg lg:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600"
          aria-controls="mobile-menu-2"
          aria-expanded="false"
        >
          <span class="sr-only">Open main menu</span>
          <svg
            class="w-6 h-6"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
            ><path
              fill-rule="evenodd"
              d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
              clip-rule="evenodd"
            ></path></svg
          >
          <svg
            class="hidden w-6 h-6"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
            ><path
              fill-rule="evenodd"
              d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
              clip-rule="evenodd"
            ></path></svg
          >
        </button>
      </div>
      <div class="hidden justify-between items-center w-full lg:flex lg:w-auto lg:order-1" id="mobile-menu-2">
        <ul class="flex flex-col mt-4 font-medium lg:flex-row lg:space-x-8 lg:mt-0">
            
            <li>
                <a href="/" class="block py-2 pr-4 pl-3 text-gray-700 border-b border-gray-100 hover:bg-gray-50 lg:hover:bg-transparent lg:border-0 lg:hover:text-primary-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white lg:dark:hover:bg-transparent dark:border-gray-700">Home</a>
            </li>
            <li>
                <a href="https://docs.fusionwallet.me" class="block py-2 pr-4 pl-3 text-gray-700 border-b border-gray-100 hover:bg-gray-50 lg:hover:bg-transparent lg:border-0 lg:hover:text-primary-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white lg:dark:hover:bg-transparent dark:border-gray-700">Documentation</a>
            </li>
            <li>
                <a href="https://github.com/Zedonboy/Fusion-Wallet/releases" class="block py-2 pr-4 pl-3 text-gray-700 border-b border-gray-100 hover:bg-gray-50 lg:hover:bg-transparent lg:border-0 lg:hover:text-primary-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white lg:dark:hover:bg-transparent dark:border-gray-700">Release</a>
            </li>
            <!-- <li>
                <a href="#" class="block py-2 pr-4 pl-3 text-gray-700 border-b border-gray-100 hover:bg-gray-50 lg:hover:bg-transparent lg:border-0 lg:hover:text-primary-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white lg:dark:hover:bg-transparent dark:border-gray-700">Team</a>
            </li>
            <li>
                <a href="#" class="block py-2 pr-4 pl-3 text-gray-700 border-b border-gray-100 hover:bg-gray-50 lg:hover:bg-transparent lg:border-0 lg:hover:text-primary-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white lg:dark:hover:bg-transparent dark:border-gray-700">Contact</a>
            </li> -->
        </ul>
    </div>
    </div>
  </nav>
</header>

<section class="bg-white dark:bg-gray-900 antialiased">
  <div class="max-w-screen-xl px-4 py-8 mx-auto lg:px-6 sm:py-16 lg:py-24">
    <div class="text-center">
      <div>
        <h2
          class="text-3xl font-extrabold leading-tight tracking-tight text-gray-900 dark:text-white sm:text-5xl lg:text-6xl"
        >
          Your Smart Wallet for the <span class="md:block"
            >Internet Computer</span
          >
        </h2>
        <p
          class="mt-4 text-base font-normal text-gray-500 dark:text-gray-400 md:max-w-3xl md:mx-auto sm:text-xl"
        >
          Experience seamless dApp interactions, secure data encryption, and
          effortless token management. Built for both users and merchants on the
          Internet Computer network.
        </p>
      </div>
      

      <div class="flex flex-col items-center justify-center gap-4 mt-8 sm:flex-row">
        <!-- <a
          target="_blank"
          href="https://onchain.fusionwallet.me"
          title=""
          class="inline-flex items-center justify-center w-full px-2 sm:px-4 py-3 text-left text-white bg-gray-900 rounded-lg sm:w-auto hover:bg-gray-800 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-300"
          role="button"
        >
          <svg
            aria-hidden="true"
            class="h-8 w-8 sm:w-10 sm:h-10"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
          >
            <path
              d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"
            ></path>
          </svg>

          <div class="ml-2.5">
            <span class="block text-xs font-normal leading-none">
              Use the
            </span>
            <span class="block text-lg font-bold leading-tight">
              Onchain Wallet
            </span>
          </div>
        </a> -->

        <a
          target="_blank"
          href="https://app.fusionwallet.me"
          title=""
          class="inline-flex items-center justify-center w-full px-2 sm:px-4 py-3 text-left text-white bg-gray-900 rounded-lg sm:w-auto hover:bg-gray-800 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-300"
          role="button"
        >
           <svg
            aria-hidden="true"
            class="h-8 w-8 sm:w-10 sm:h-10"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
          >
            <path
              d="M19.665 16.811a10.316 10.316 0 0 1-1.021 1.837c-.537.767-.978 1.297-1.316 1.592-.525.482-1.089.73-1.692.744-.432 0-.954-.123-1.562-.373-.61-.249-1.17-.371-1.683-.371-.537 0-1.113.122-1.73.371-.616.25-1.114.381-1.495.393-.577.025-1.154-.229-1.729-.764-.367-.32-.826-.87-1.377-1.648-.59-.829-1.075-1.794-1.455-2.891-.407-1.187-.611-2.335-.611-3.447 0-1.273.275-2.372.826-3.292a4.857 4.857 0 0 1 1.73-1.751 4.65 4.65 0 0 1 2.34-.662c.46 0 1.063.142 1.81.422s1.227.422 1.436.422c.158 0 .689-.167 1.593-.498.853-.307 1.573-.434 2.163-.384 1.6.129 2.801.759 3.6 1.895-1.43.867-2.137 2.08-2.123 3.637.012 1.213.453 2.222 1.317 3.023a4.33 4.33 0 0 0 1.315.863c-.106.307-.218.6-.336.882zM15.998 2.38c0 .95-.348 1.838-1.039 2.659-.836.976-1.846 1.541-2.941 1.452a2.955 2.955 0 0 1-.021-.36c0-.913.396-1.889 1.103-2.688.352-.404.8-.741 1.343-1.009.542-.264 1.054-.41 1.536-.435.013.128.019.255.019.381z"
            >
            </path>
          </svg>

          <div class="ml-2.5">
            <span class="block text-xs font-normal leading-none">
              Use the
            </span>
            <span class="block text-lg font-bold leading-tight">
              Web Version
            </span>
          </div>
        </a>

        <a
          href="#"
          on:click|preventDefault={handleDownload}
          title=""
          class="inline-flex items-center justify-center w-full px-2 sm:px-4 py-3 text-left text-white bg-gray-900 rounded-lg sm:w-auto hover:bg-gray-800 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-300"
          role="button"
        >
           <svg aria-hidden="true" class="h-8 w-8 sm:w-10 sm:h-10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                        fill="currentColor">
                        <path
                            d="m12.954 11.616 2.957-2.957L6.36 3.291c-.633-.342-1.226-.39-1.746-.016l8.34 8.341zm3.461 3.462 3.074-1.729c.6-.336.929-.812.929-1.34 0-.527-.329-1.004-.928-1.34l-2.783-1.563-3.133 3.132 2.841 2.84zM4.1 4.002c-.064.197-.1.417-.1.658v14.705c0 .381.084.709.236.97l8.097-8.098L4.1 4.002zm8.854 8.855L4.902 20.91c.154.059.32.09.495.09.312 0 .637-.092.968-.276l9.255-5.197-2.666-2.67z">
                        </path>
                    </svg>

          <div class="ml-2.5">
            <span class="block text-xs font-normal leading-none">
              Download for
            </span>
            <span class="block text-lg font-bold leading-tight">
              Android {latestVersion ? `v${latestVersion}` : ''}
            </span>
          </div>
        </a>

        <!-- <a
          href="#"
          title=""
          class="inline-flex items-center justify-center w-full px-2 sm:px-4 py-3 text-left text-white bg-gray-900 rounded-lg sm:w-auto hover:bg-gray-800 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-300"
          role="button"
        >
          <svg
            aria-hidden="true"
            class="h-8 w-8 sm:w-10 sm:h-10"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
          >
            <path
              d="M19.665 16.811a10.316 10.316 0 0 1-1.021 1.837c-.537.767-.978 1.297-1.316 1.592-.525.482-1.089.73-1.692.744-.432 0-.954-.123-1.562-.373-.61-.249-1.17-.371-1.683-.371-.537 0-1.113.122-1.73.371-.616.25-1.114.381-1.495.393-.577.025-1.154-.229-1.729-.764-.367-.32-.826-.87-1.377-1.648-.59-.829-1.075-1.794-1.455-2.891-.407-1.187-.611-2.335-.611-3.447 0-1.273.275-2.372.826-3.292a4.857 4.857 0 0 1 1.73-1.751 4.65 4.65 0 0 1 2.34-.662c.46 0 1.063.142 1.81.422s1.227.422 1.436.422c.158 0 .689-.167 1.593-.498.853-.307 1.573-.434 2.163-.384 1.6.129 2.801.759 3.6 1.895-1.43.867-2.137 2.08-2.123 3.637.012 1.213.453 2.222 1.317 3.023a4.33 4.33 0 0 0 1.315.863c-.106.307-.218.6-.336.882zM15.998 2.38c0 .95-.348 1.838-1.039 2.659-.836.976-1.846 1.541-2.941 1.452a2.955 2.955 0 0 1-.021-.36c0-.913.396-1.889 1.103-2.688.352-.404.8-.741 1.343-1.009.542-.264 1.054-.41 1.536-.435.013.128.019.255.019.381z"
            >
            </path>
          </svg>

          <div class="ml-2.5">
            <span class="block text-xs font-normal leading-none">
              Download on
            </span>
            <span class="block text-lg font-bold leading-tight">
              AppStore
            </span>
          </div>
        </a> -->
      </div>
    </div>

    <div class="my-8 sm:my-16">
      <div
        class="relative mx-auto border-gray-800 dark:border-gray-800 dark:bg-gray-800 border-[14px] rounded-[2.5rem] h-[600px] w-[300px]"
      >
        <div
          class="h-[32px] w-[3px] bg-gray-800 dark:bg-gray-800 absolute -left-[17px] top-[72px] rounded-l-lg"
        ></div>
        <div
          class="h-[46px] w-[3px] bg-gray-800 dark:bg-gray-800 absolute -left-[17px] top-[124px] rounded-l-lg"
        ></div>
        <div
          class="h-[46px] w-[3px] bg-gray-800 dark:bg-gray-800 absolute -left-[17px] top-[178px] rounded-l-lg"
        ></div>
        <div
          class="h-[64px] w-[3px] bg-gray-800 dark:bg-gray-800 absolute -right-[17px] top-[142px] rounded-r-lg"
        ></div>
        <div
          class="rounded-[1rem] overflow-hidden w-[272px] h-[572px] bg-white dark:bg-gray-800"
        >
          <!-- <img
            src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/hero/mockup-1-light.png"
            class="dark:hidden w-[272px] h-[572px]"
            alt=""
          /> -->
          <img
            src="fusion_home_rec.png"
            class="dark:block w-[272px] h-[572px]"
            alt=""
          />
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Features -->
<section class="bg-white dark:bg-gray-900 antialiased">
  <div class="max-w-screen-xl px-4 py-8 mx-auto lg:px-6 sm:py-16 lg:py-24">
    <div class="max-w-3xl mx-auto text-center">
      <h2
        class="text-3xl font-extrabold leading-tight tracking-tight text-gray-900 sm:text-4xl dark:text-white"
      >
        Your All-in-One Web3 Command Center
      </h2>
      <p
        class="mt-4 text-base font-normal text-gray-500 sm:text-xl dark:text-gray-400"
      >
        Control your financial destiny from your mobile phone
      </p>
    </div>

    <div
      class="p-4 mt-8 rounded-lg sm:p-12 lg:mt-16 bg-gray-50 dark:bg-gray-800"
    >
      <div class="grid grid-cols-1 gap-8 sm:gap-12 lg:grid-cols-2">
        <div class="flex flex-col items-start gap-4 sm:gap-5 sm:flex-row">
          <div
            class="bg-gray-100 dark:bg-gray-700 rounded-full w-16 h-16 lg:w-24 lg:h-24 flex items-center justify-center shrink-0"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-10 lg:w-12 h-10 lg:h-12 text-primary-600 dark:text-primary-500"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M3.75 4.875c0-.621.504-1.125 1.125-1.125h4.5c.621 0 1.125.504 1.125 1.125v4.5c0 .621-.504 1.125-1.125 1.125h-4.5A1.125 1.125 0 0 1 3.75 9.375v-4.5ZM3.75 14.625c0-.621.504-1.125 1.125-1.125h4.5c.621 0 1.125.504 1.125 1.125v4.5c0 .621-.504 1.125-1.125 1.125h-4.5a1.125 1.125 0 0 1-1.125-1.125v-4.5ZM13.5 4.875c0-.621.504-1.125 1.125-1.125h4.5c.621 0 1.125.504 1.125 1.125v4.5c0 .621-.504 1.125-1.125 1.125h-4.5A1.125 1.125 0 0 1 13.5 9.375v-4.5Z"
              />
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M6.75 6.75h.75v.75h-.75v-.75ZM6.75 16.5h.75v.75h-.75v-.75ZM16.5 6.75h.75v.75h-.75v-.75ZM13.5 13.5h.75v.75h-.75v-.75ZM13.5 19.5h.75v.75h-.75v-.75ZM19.5 13.5h.75v.75h-.75v-.75ZM19.5 19.5h.75v.75h-.75v-.75ZM16.5 16.5h.75v.75h-.75v-.75Z"
              />
            </svg>
          </div>
          <div>
            <h3
              class="text-xl font-bold text-gray-900 sm:text-2xl dark:text-white"
            >
              Smart POS for Merchants
            </h3>
            <p
              class="mt-2 text-base font-normal text-gray-500 sm:text-lg dark:text-gray-400"
            >
              Convert any device into a crypto payment terminal with instant
              ICRC-1 token settlements and automated invoicing.
            </p>
          </div>
        </div>

        <div class="flex flex-col items-start gap-4 sm:gap-5 sm:flex-row">
          <div
            class="bg-gray-100 dark:bg-gray-700 rounded-full w-16 h-16 lg:w-24 lg:h-24 flex items-center justify-center shrink-0"
          >
            <svg
              class="w-10 lg:w-12 h-10 lg:h-12 text-primary-600 dark:text-primary-500"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="size-6"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z"
                />
              </svg>
            </svg>
          </div>
          <div>
            <h3
              class="text-xl font-bold text-gray-900 sm:text-2xl dark:text-white"
            >
              Advanced Security
            </h3>
            <p
              class="mt-2 text-base font-normal text-gray-500 sm:text-lg dark:text-gray-400"
            >
              End-to-end encryption and secure canister management protect your
              digital assets.
            </p>
          </div>
        </div>

        <div class="flex flex-col items-start gap-4 sm:gap-5 sm:flex-row">
          <div
            class="bg-gray-100 dark:bg-gray-700 rounded-full w-16 h-16 lg:w-24 lg:h-24 flex items-center justify-center shrink-0"
          >
            <svg
              class="w-10 lg:w-12 h-10 lg:h-12 text-primary-600 dark:text-primary-500"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="size-6"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M13.19 8.688a4.5 4.5 0 0 1 1.242 7.244l-4.5 4.5a4.5 4.5 0 0 1-6.364-6.364l1.757-1.757m13.35-.622 1.757-1.757a4.5 4.5 0 0 0-6.364-6.364l-4.5 4.5a4.5 4.5 0 0 0 1.242 7.244"
                />
              </svg>
            </svg>
          </div>
          <div>
            <h3
              class="text-xl font-bold text-gray-900 sm:text-2xl dark:text-white"
            >
              Easy dApp Interactions
            </h3>
            <p
              class="mt-2 text-base font-normal text-gray-500 sm:text-lg dark:text-gray-400"
            >
              Seamless connection and interaction with Internet Computer dApps.
            </p>
          </div>
        </div>

        <!-- <div class="flex flex-col items-start gap-4 sm:gap-5 sm:flex-row">
          <div
            class="bg-gray-100 dark:bg-gray-700 rounded-full w-16 h-16 lg:w-24 lg:h-24 flex items-center justify-center shrink-0"
          >
            <svg
              class="w-10 lg:w-12 h-10 lg:h-12 text-primary-600 dark:text-primary-500"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z"
              ></path>
            </svg>
          </div>
          <div>
            <h3
              class="text-xl font-bold text-gray-900 sm:text-2xl dark:text-white"
            >
              Reports and Analytics
            </h3>
            <p
              class="mt-2 text-base font-normal text-gray-500 sm:text-lg dark:text-gray-400"
            >
              We provide detailed reports and analytics that help users
              understand their spending habits, and make more informed financial
              decisions.
            </p>
          </div>
        </div> -->

        <!-- <div class="flex flex-col items-start gap-4 sm:gap-5 sm:flex-row">
          <div
            class="bg-gray-100 dark:bg-gray-700 rounded-full w-16 h-16 lg:w-24 lg:h-24 flex items-center justify-center shrink-0"
          >
            <svg
              class="w-10 lg:w-12 h-10 lg:h-12 text-primary-600 dark:text-primary-500"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z"
              ></path>
            </svg>
          </div>
          <div>
            <h3
              class="text-xl font-bold text-gray-900 sm:text-2xl dark:text-white"
            >
              Cloud synchronization
            </h3>
            <p
              class="mt-2 text-base font-normal text-gray-500 sm:text-lg dark:text-gray-400"
            >
              Synch your data across multiple devices, so you can access your
              budget and expenses from anywhere, at any time, and on any device.
            </p>
          </div>
        </div> -->

        <div class="flex flex-col items-start gap-4 sm:gap-5 sm:flex-row">
          <div
            class="bg-gray-100 dark:bg-gray-700 rounded-full w-16 h-16 lg:w-24 lg:h-24 flex items-center justify-center shrink-0"
          >
            <svg
              class="w-10 lg:w-12 h-10 lg:h-12 text-primary-600 dark:text-primary-500"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
              ></path>
            </svg>
          </div>
          <div>
            <h3
              class="text-xl font-bold text-gray-900 sm:text-2xl dark:text-white"
            >
              Alerts and notifications
            </h3>
            <p
              class="mt-2 text-base font-normal text-gray-500 sm:text-lg dark:text-gray-400"
            >
              Get Notification on all activities that happened on chain
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- <div class="mt-8 text-center lg:mt-16">
      <a
        href="https://github.com/Zedonboy/Fusion-Wallet/releases"
        title=""
        class="text-white inline-flex items-center bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
        role="button"
      >
        Download Apk
        <svg
          aria-hidden="true"
          class="w-5 h-5 ml-2 -mr-1"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
        >
          <path
            fill-rule="evenodd"
            d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z"
            clip-rule="evenodd"
          />
        </svg>
      </a>
    </div> -->
  </div>
</section>

<!-- Content -->
<section class="bg-white dark:bg-gray-900">
  <div
    class="gap-8 items-center py-8 px-4 mx-auto max-w-screen-xl xl:gap-16 md:grid md:grid-cols-2 sm:py-16 lg:px-6"
  >
    <div>
      <h2
        class="mb-4 text-4xl tracking-tight font-extrabold text-gray-900 dark:text-white"
      >
        Ready to Get Started?
      </h2>
      <p class="mb-6 font-light text-gray-500 md:text-lg dark:text-gray-400">
        Download Fusion Wallet now and experience the future of digital asset
        management on Internet Computer.
      </p>
      <!-- <a
        href="#"
        class="text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800"
      >
        Download Apk
      </a> -->
      <!-- <div class="items-center space-y-4 sm:flex sm:space-y-0 sm:space-x-4">
              <a href="#" class="w-full sm:w-auto bg-gray-800 hover:bg-gray-700 focus:ring-4 focus:outline-none focus:ring-gray-300 text-white rounded-lg inline-flex items-center justify-center px-4 py-2.5 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-800">
                  <svg class="mr-3 w-7 h-7" aria-hidden="true" focusable="false" data-prefix="fab" data-icon="apple" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512"><path fill="currentColor" d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"></path></svg>
                  <div class="text-left">
                      <div class="mb-1 text-xs">Download on the</div>
                      <div class="-mt-1 font-sans text-sm font-semibold">Mac App Store</div>
                  </div>
              </a>
              <a href="#" class="w-full sm:w-auto bg-gray-800 hover:bg-gray-700 focus:ring-4 focus:outline-none focus:ring-gray-300 text-white rounded-lg inline-flex items-center justify-center px-4 py-2.5 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-800">
                  <svg class="mr-3 w-7 h-7" aria-hidden="true" focusable="false" data-prefix="fab" data-icon="google-play" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path fill="currentColor" d="M325.3 234.3L104.6 13l280.8 161.2-60.1 60.1zM47 0C34 6.8 25.3 19.2 25.3 35.3v441.3c0 16.1 8.7 28.5 21.7 35.3l256.6-256L47 0zm425.2 225.6l-58.9-34.1-65.7 64.5 65.7 64.5 60.1-34.1c18-14.3 18-46.5-1.2-60.8zM104.6 499l280.8-161.2-60.1-60.1L104.6 499z"></path></svg>
                  <div class="text-left">
                      <div class="mb-1 text-xs">Get it on</div>
                      <div class="-mt-1 font-sans text-sm font-semibold">Google Play</div>
                  </div>
              </a>
          </div> -->
    </div>
    <img
      class="hidden mx-auto w-64 md:flex"
      src="fusion_receive_ss.png"
      alt="mobile app"
    />
  </div>
</section>

<!-- Subscribe -->
<!-- <section class="bg-white dark:bg-gray-900">
  <div class="py-8 px-4 mx-auto max-w-screen-xl sm:py-16 lg:px-6">
    <div class="mx-auto max-w-screen-md text-center">
      <h2
        class="mb-4 text-4xl tracking-tight font-extrabold text-gray-900 dark:text-white"
      >
        Get started with Fusion today
      </h2>
      <p class="mb-6 font-light text-gray-500 md:text-lg dark:text-gray-400">
        Connecting with your audience has never been easier with Fusion
        straightforward email marketing and automation tools.
      </p>
      <form action="#" class="mx-auto max-w-screen-sm">
        <div class="flex items-center mb-3">
          <div class="relative mr-3 w-full">
            <label
              for="member_email"
              class="hidden mb-2 text-sm font-medium text-gray-900 dark:text-gray-300"
              >Email address</label
            >
            <div
              class="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none"
            >
              <svg
                class="w-5 h-5 text-gray-500 dark:text-gray-400"
                fill="currentColor"
                viewBox="0 0 20 20"
                xmlns="http://www.w3.org/2000/svg"
                ><path
                  d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"
                ></path><path
                  d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"
                ></path></svg
              >
            </div>
            <input
              class="block p-3 pl-10 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
              placeholder="Enter your email"
              type="email"
              name="member[email]"
              id="member_email"
              required=""
            />
          </div>
          <div>
            <input
              type="submit"
              value="Subscribe"
              class="py-3 px-5 text-sm font-medium text-center text-white rounded-lg cursor-pointer bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800"
              name="member_submit"
              id="member_submit"
            />
          </div>
        </div>
        <div
          class="text-sm font-medium text-left text-gray-500 dark:text-gray-300"
        >
          Instant signup. No credit card required. <a
            href="#"
            class="text-primary-600 hover:underline dark:text-primary-500"
            >Terms of Service</a
          >
          and
          <a
            class="text-primary-600 hover:underline dark:text-primary-500"
            href="#">Privacy Policy</a
          >.
        </div>
      </form>
    </div>
  </div>
</section> -->

<!-- Footer -->
<footer class="p-4 bg-white md:p-8 lg:p-10 dark:bg-gray-800">
  <div class="mx-auto max-w-screen-xl text-center">
    <a
      href="#"
      class="flex justify-center items-center text-2xl font-semibold text-gray-900 dark:text-white"
    >
      <img
        src="fusion_web_logo.png"
        class="mr-3 h-6 sm:h-9"
        alt="Fusion Logo"
      />
      Fusion
    </a>

    <div class="mt-8">
      <span class="text-sm text-gray-500 sm:text-center dark:text-gray-400">© {current_year} <a href="#" class="hover:underline">Fusion</a>. All Rights Reserved.</span>
    </div>
  </div>
</footer>

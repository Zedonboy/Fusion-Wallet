import { AuthClient} from "@dfinity/auth-client"


async function identity_sign_in() {
    const authClient = await AuthClient.create()

    await authClient.login({
        onSuccess: () => {
            console.log()
            console.log("Signed in")
        },
        onError: (error) => {
            console.error("Error signing in", error)
        }
    })
}